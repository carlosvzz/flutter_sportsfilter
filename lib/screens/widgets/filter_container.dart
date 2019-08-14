import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsfilter/providers/game_model.dart';

class FilterContainer extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    GameModel appModel = Provider.of<GameModel>(context);

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
                  print(appModel.dateIni.date.toString());
                  appModel.dateIni.date =
                      await _selectDate(context, appModel.dateIni.date);
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
                },
              ),
            ],
          ),

          ///TYPE BET
          Row(
            children: <Widget>[
              LabelContainer('Bet Type'),
              Placeholder(
                fallbackHeight: 30,
                fallbackWidth: 300,
              ),
            ],
          ),

          ///Time of Day
          Row(
            children: <Widget>[
              LabelContainer('Time of Day'),
              Placeholder(
                fallbackHeight: 30,
                fallbackWidth: 300,
              ),
            ],
          ),

          ///Sports
          Row(
            children: <Widget>[
              LabelContainer('Sports'),
              Placeholder(
                fallbackHeight: 30,
                fallbackWidth: 300,
              ),
            ],
          ),

          ///Order by
          Row(
            children: <Widget>[
              LabelContainer('Order by'),
              Placeholder(
                fallbackHeight: 30,
                fallbackWidth: 300,
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
      width: 110,
      alignment: Alignment.center,
      child: Text(texto),
    );
  }
}
