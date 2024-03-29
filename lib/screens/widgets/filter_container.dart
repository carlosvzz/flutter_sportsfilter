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
  List<ORDER_BY> _listaOrderBy;
  List<TIME_OF_DAY> _listaTimeOfDay;
  List<TYPE_BET> _listBets;
  List<TYPE_SPORTS> _listSports;

  @override
  void initState() {
    super.initState();

    _listaTimeOfDay = TIME_OF_DAY.values.toList();
    _listaOrderBy = ORDER_BY.values.toList();
    _listBets = TYPE_BET.values.toList();
    _listSports = TYPE_SPORTS.values.toList();
  }

  Future<DateTime> _selectDate(
      BuildContext context, DateTime currentDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(Duration(days: 30)),
      lastDate: currentDate.add(Duration(days: 30)),
      locale: const Locale("es", "ES"),
    );

    if (picked == null) {
      return currentDate;
    } else {
      return picked;
    }
  }

  // This function will open the dialog
  _showMultiSelectDialog(AppModel app, bool isBets) {
    List<String> listaAux;
    List<String> listaSelAux;

    if (isBets) {
      listaAux = _listBets.map((b) {
        return enumToString(b);
      }).toList();

      listaSelAux = app.filterTypeBet.map((b) {
        return enumToString(b);
      }).toList();
    } else {
      // Sports
      listaAux = _listSports.map((b) {
        return enumToString(b);
      }).toList();

      listaSelAux = app.filterSport.map((b) {
        return enumToString(b);
      }).toList();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              isBets ? "Type of Bet" : "Sports",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            content: MultiSelectChip(
              listaAux,
              listaSelAux,
              onSelectionChanged: (selectedList) {
                if (isBets) {
                  app.filterTypeBet = [];
                } else {
                  app.filterSport = [];
                }

                setState(() {
                  selectedList.forEach((i) {
                    if (isBets) {
                      app.filterTypeBet.add(enumFromString(i, TYPE_BET.values));
                    } else {
                      app.filterSport
                          .add(enumFromString(i, TYPE_SPORTS.values));
                    }
                  });
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "OK",
                  style: Theme.of(context).accentTextTheme.body1,
                ),
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
                    _showMultiSelectDialog(appModel, true);
                  },
                ),
              ),
              Text(appModel.filterTypeBet
                  .map((i) {
                    return enumToString(i);
                  })
                  .toList()
                  .join(" , ")),
            ],
          ),

          ///Sports
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                width: 130,
                child: RaisedButton(
                  child: Text('Sports'),
                  onPressed: () {
                    _showMultiSelectDialog(appModel, false);
                  },
                ),
              ),
              Text(appModel.filterSport
                  .map((i) {
                    return enumToString(i);
                  })
                  .toList()
                  .join(" , ")),
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
