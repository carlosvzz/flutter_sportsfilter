import 'package:flutter/material.dart';
import 'package:sportsfilter/screens/widgets/filter_container.dart';

class ScreenFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Filters')),
        body: Column(
          children: <Widget>[
            Expanded(
              child: FilterContainer(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("OK"),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            )
          ],
        ));
  }
}
