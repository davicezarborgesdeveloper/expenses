import 'package:expenses/components/transaction_item.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this.transactions, this.onRemove);

  final List<Transaction> transactions;
  final void Function(String) onRemove;
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, contraints) {
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Nenhuma Transação Cadasatrada!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                Container(
                  height: contraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        // : ListView(
        //     children: transactions.map((tr) {
        //       return TransactionItem(
        //         key: ValueKey(tr.id),
        //         tr: tr,
        //         onRemove: onRemove,
        //       );
        //     }).toList(),
        //   );
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (_, index) {
              final tr = transactions[index];
              return TransactionItem(
                  key: GlobalObjectKey(tr), tr: tr, onRemove: onRemove);
            },
          );
  }
}
