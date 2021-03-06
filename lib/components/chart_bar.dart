import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double percentege;

  const ChartBar({this.label, this.value, this.percentege});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, contraints) {
        return Column(
          children: [
            Container(
              height: contraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('${value.toStringAsFixed(2)}'),
              ),
            ),
            SizedBox(
              height: contraints.maxHeight * 0.15,
            ),
            Container(
              height: contraints.maxHeight * 0.5,
              width: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentege,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: contraints.maxHeight * 0.05,
            ),
            Container(
                height: contraints.maxHeight * 0.15,
                child: FittedBox(child: Text(label))),
          ],
        );
      },
    );
  }
}
