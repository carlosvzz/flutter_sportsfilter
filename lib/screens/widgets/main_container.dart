import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sportsfilter/providers/app_model.dart';
//import 'package:flutter_selectable_text/flutter_selectable_text.dart';

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  Future<String> _listaJuegos;
  String textoFinal;
  AppModel oGame;

  @override
  void initState() {
    super.initState();
    oGame = Provider.of<AppModel>(context, listen: false);
    _listaJuegos = oGame.getGames();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              child: FutureBuilder<String>(
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
                  textoFinal = snapshot.data;
                  return SingleChildScrollView(
                      child: SelectableText(
                    snapshot.data,
                    style: Theme.of(context).textTheme.body1,
                  ));
                }
              }
            },
          )),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(Icons.filter_list),
                label: Text("Filtros"),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/filtros');
                  setState(() {
                    _listaJuegos = oGame.getGames();
                  });
                },
              ),
              RaisedButton.icon(
                icon: Icon(Icons.content_copy),
                label: Text("Copiar"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: textoFinal));
                  toast('Texto copiado!!..');
                },
              ),
              RaisedButton.icon(
                icon: Icon(Icons.refresh),
                label: Text("Actualizar"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  setState(() {
                    _listaJuegos = oGame.getGames();
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
