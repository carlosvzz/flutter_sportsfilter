import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsfilter/providers/app_model.dart';
import 'package:sportsfilter/screens/widgets/multiselect_chip.dart';

class FilterContainer extends StatefulWidget {
  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  // Filtro enum TIMEOFDAY { ALL, MORNING, NIGHT }
  List<String> _timeOfDay = ['<All>', 'Morning', 'Night'];
  String _selTimeOfDay;
  // Order BY enum ORDERBY { MAXVALUE, DATETIME, TYPEBET }
  List<String> _orderBy = ['Value', 'Date', 'Bet'];
  String _selOrderBy;
  // Type of Bets enum TYPEBET { ML, SPREAD, OVERUNDER, BTTS }
  List<String> _typeBets = ['ML', 'Spread', 'Over/Under', 'BTTS'];
  List<String> _seltypeBets = List();

  Future<DateTime> _selectDate(
      BuildContext context, DateTime currentDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(Duration(days: 30)),
      lastDate: currentDate.add(Duration(days: 30)),
      //locale: const Locale("es", "ES"),
    );

    if (picked == null) {
      return currentDate;
    } else {
      return picked;
    }
  }

  // This function will open the dialog
  _showMultiSelectDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Type of Bet"),
            content: MultiSelectChip(
              _typeBets,
              onSelectionChanged: (selectedList) {
                setState(() {
                  _seltypeBets = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AppModel appModel = Provider.of<AppModel>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ////FECHA
          Row(
            children: <Widget>[
              LabelContainer('Date'),
              RaisedButton(
                child: Text(appModel.dateIni.getLabel),
                onPressed: () async {
                  appModel.dateIni.date =
                      await _selectDate(context, appModel.dateIni.date);
                  setState(() {});
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              RaisedButton(
                child: Text(appModel.dateFin.getLabel),
                onPressed: () async {
                  appModel.dateFin.date =
                      await _selectDate(context, appModel.dateFin.date);
                  setState(() {});
                },
              ),
            ],
          ),

          ///Order by
          Row(
            children: <Widget>[
              LabelContainer('Order by'),
              DropdownButton(
                hint: Text('Select option'), // Not necessary for Option 1
                value: _selOrderBy,
                onChanged: (newValue) {
                  switch (newValue) {
                    case 'Value':
                      appModel.filterOrderBy = ORDERBY.MAXVALUE;
                      break;
                    case 'Date':
                      appModel.filterOrderBy = ORDERBY.DATETIME;
                      break;
                    case 'Bet':
                      appModel.filterOrderBy = ORDERBY.TYPEBET;
                      break;
                  }

                  setState(() {
                    _selOrderBy = newValue;
                  });
                },
                items: _orderBy.map((order) {
                  return DropdownMenuItem(
                    child: Text(
                      order,
                      style: Theme.of(context).textTheme.display1,
                    ),
                    value: order,
                  );
                }).toList(),
              ),
            ],
          ),

          ///Time of Day
          Row(
            children: <Widget>[
              LabelContainer('Time of Day'),
              DropdownButton(
                hint: Text('Select option'), // Not necessary for Option 1
                value: _selTimeOfDay,
                onChanged: (newValue) {
                  switch (newValue) {
                    case '<All>':
                      appModel.filterTimeofDay = TIMEOFDAY.ALL;
                      break;
                    case 'Morning':
                      appModel.filterTimeofDay = TIMEOFDAY.MORNING;
                      break;
                    case 'Night':
                      appModel.filterTimeofDay = TIMEOFDAY.NIGHT;
                      break;
                  }
                  setState(() {
                    _selTimeOfDay = newValue;
                  });
                },
                items: _timeOfDay.map((time) {
                  return DropdownMenuItem(
                    child: Text(
                      time,
                      style: Theme.of(context).textTheme.display1,
                    ),
                    value: time,
                  );
                }).toList(),
              ),
            ],
          ),

          ///BET TYPE
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                width: 130,
                child: RaisedButton(
                  child: Text('Bet Types'),
                  onPressed: () {
                    _showMultiSelectDialog();
                  },
                ),
              ),
              Text(_seltypeBets.join(" , ")),
            ],
          ),

          ///Sports
          Row(
            children: <Widget>[
              LabelContainer('Sports'),
              Placeholder(
                fallbackHeight: 30,
                fallbackWidth: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LabelContainer extends StatelessWidget {
  final String texto;
  LabelContainer(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      alignment: Alignment.center,
      child: Text(
        texto,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
