import 'dart:io';
import 'dart:math';

import 'package:desktop_window/desktop_window.dart';
import 'package:expanses/components/chart.dart';
import 'package:expanses/components/transaction_form.dart';
import 'package:expanses/components/transaction_list.dart';
import 'package:expanses/models/transaction.dart';
import 'package:flutter/material.dart';

var screenHeight = 0.0;
var screenWidth = 0.0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setWindowSizeDesktop();
  runApp(ExpensesApp());
}

setWindowSizeDesktop() async {
  if (Platform.isWindows) {
    screenWidth = 392.72727272727275;
    screenHeight = 825.4545454545455;
    await DesktopWindow.setWindowSize(Size(screenWidth, screenHeight));
  }
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final ThemeData tema = ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _changeOrientation() async {
    var auxSize = 0.0;
    auxSize = screenHeight;
    screenHeight = screenWidth;
    screenWidth = auxSize;
    await DesktopWindow.setWindowSize(Size(screenWidth, screenHeight));
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        // style: TextStyle(fontSize: 10 * MediaQuery.of(context).textScaleFactor),
      ),
      actions: [
        if (Platform.isWindows)
          IconButton(
            onPressed: () => _changeOrientation(),
            icon: Icon(Icons.change_circle_outlined),
          ),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: Icon(Icons.add),
        )
      ],
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Exibir Gráfico'),
                Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    }),
              ],
            ),
            _showChart
                ? Container(
                    height: availableHeight * 0.3,
                    child: Chart(_recentTransactions))
                : Container(
                    height: availableHeight * 0.7,
                    child: TransactionList(_transactions, _removeTransaction)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
