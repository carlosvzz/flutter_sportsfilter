import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsfilter/providers/game_model.dart';

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  Future<List<String>> _listaJuegos;
  GameModel oGame;

  @override
  void initState() {
    super.initState();
    oGame = Provider.of<GameModel>(context, listen: false);
    _listaJuegos = oGame.getList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Flexible(
              child: FutureBuilder<List<String>>(
            future: _listaJuegos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data == null) {
                  return new Text('No hay juegos');
                } else {
                  // handle the case that data is null
                  return ListView(
                    children: snapshot.data.map((data) {
                      return ListTile(
                        title: Text(data.toString()),
                      );
                    }).toList(),
                  );
                }
              }
            },
          )),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Text("REFRESH"),
            color: Theme.of(context).accentColor,
            onPressed: () {
              setState(() {
                _listaJuegos = oGame.getList();
              });
            },
          ),
        ],
      ),
    );
  }
}
