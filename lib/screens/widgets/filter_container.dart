import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsfilter/helpers/enums.dart';
import 'package:sportsfilter/providers/app_model.dart';
import 'package:sportsfilter/screens/widgets/multiselect_chip.dart';

class FilterContainer extends StatefulWidget {
  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  List<TIME_OF_DAY> _listaTimeOfDay;
  List<ORDER_BY> _listaOrderBy;

  @override
  void initState() {
    super.initState();

    _listaTimeOfDay = TIME_OF_DAY.values.toList();
    _listaOrderBy = ORDER_BY.values.toList();
  }

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
                value: enumToString(appModel.filterOrderBy),
                onChanged: (newValue) {
                  setState(() {
                    appModel.filterOrderBy =
                        enumFromString(newValue, ORDER_BY.values);
                  });
                },
                items: _listaOrderBy.map((order) {
                  return DropdownMenuItem(
                    child: Text(
                      enumToString(order),
                      style: Theme.of(context).textTheme.display1,
                    ),
                    value: enumToString(order),
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
                value: enumToString(appModel.filterTimeofDay),
                onChanged: (newValue) {
                  print('Valor es $newValue');
                  setState(() {
                    appModel.filterTimeofDay = enumFromString<TIME_OF_DAY>(
                        newValue, TIME_OF_DAY.values);
                  });
                },
                items: _listaTimeOfDay.map((time) {
                  return DropdownMenuItem(
                    child: Text(
                      enumToString(time),
                      style: Theme.of(context).textTheme.display1,
                    ),
                    value: enumToString(time),
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
