// import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queries/collections.dart';
import 'package:sportsfilter/models/custom_date.dart';
import 'package:sportsfilter/models/game.dart';
import 'package:sportsfilter/models/game_bet.dart';

enum TIMEOFDAY { ALL, MORNING, NIGHT }
enum ORDERBY { MAXVALUE, DATETIME, TYPEBET }

class GameModel with ChangeNotifier {
  int numRegs;
  CustomDate dateIni;
  CustomDate dateFin;
  List<String> filterSport = [];
  List<String> filterTypeBet = [];
  TIMEOFDAY filterTimeofDay = TIMEOFDAY.ALL;
  ORDERBY filterOrderBy = ORDERBY.MAXVALUE;
  bool isLoading = false;
  List<GameBet> _listaBet;

  GameModel() {
    dateIni = new CustomDate(DateTime.now().subtract(Duration(days: 1)));
    dateFin = new CustomDate(DateTime.now());
  }

  Future<String> getGames() async {
    try {
      CollectionReference collectionRef =
          Firestore.instance.collection("games");

// Obtener juegos con rango de fechas
      QuerySnapshot collection = await collectionRef
          .where('date', isGreaterThanOrEqualTo: dateIni.date)
          .where('date', isLessThanOrEqualTo: dateFin.date)
          .orderBy('date')
          .orderBy('time')
          .getDocuments();
//Filtrar lista
      Future<String> listaFiltrada = _filtrarLista(collection.documents);

      return listaFiltrada;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> _filtrarLista(List<DocumentSnapshot> documentos) async {
    List<String> listaFiltrada = [];
    _listaBet = [];

    // Revisar juegos validos
    await Future.wait(documentos.map((doc) async {
      Game game = Game.fromMap(doc.data);
      _revisarGame(game);
    }));

    // Armar lista de string
    if (_listaBet != null) {
      var query = Collection(_listaBet)
          .orderBy((f) => f.minValue)
          .thenByDescending((f) => f.maxValue);

      listaFiltrada = query.asIterable().map((bet) {
        return bet.label;
      }).toList();
    }
    numRegs = listaFiltrada.length;

    return numRegs.toString() + '\n' + listaFiltrada.join('\n');
  }

  void _revisarGame(Game oGame) {
    String textoFinal;
    String datoJuego;
    String etiquetaJuego;
    bool esSoccer;
    bool hayDifWin;
    int teamGanador;
    int maxValue;
    int minValue;

    esSoccer = oGame.idSport.toLowerCase().contains('soccer');
    etiquetaJuego =
        esSoccer ? oGame.idSport.replaceAll('Soccer', 'FB') : oGame.idSport;

    String teamAway = oGame.awayTeam.abbreviation.padRight(3);
    String teamHome = oGame.homeTeam.abbreviation.padRight(3);

    if (esSoccer) {
      datoJuego = '$etiquetaJuego (${oGame.time}) $teamHome v $teamAway > ';
    } else {
      // US Games
      datoJuego = '$etiquetaJuego (${oGame.time}) $teamAway @ $teamHome >';
    }

    ///////////////////////// MAIN //////////////////////////////
    teamGanador = -1;
    hayDifWin = false;

    if (esSoccer) {
      // DIFERENCIA CON MAS DE +2 VOTOS VS EL RESTO
      // Gana visitante
      if (oGame.countAway - (oGame.countHome + oGame.countDraw) > 2) {
        teamGanador = 2;
        hayDifWin = true;
        maxValue = oGame.countAway;
        minValue = oGame.countHome + oGame.countDraw;
      }
      // Gana Local
      if (!hayDifWin &&
          (oGame.countHome - (oGame.countAway + oGame.countDraw) > 2)) {
        teamGanador = 1;
        hayDifWin = true;
        maxValue = oGame.countHome;
        minValue = oGame.countAway + oGame.countDraw;
      }
      // EMPATE
      if (!hayDifWin &&
          (oGame.countDraw - (oGame.countAway + oGame.countHome) > 2)) {
        teamGanador = 0;
        hayDifWin = true;
        maxValue = oGame.countDraw;
        minValue = oGame.countHome + oGame.countDraw;
      }
    } else {
//US Games > Gana cualquiera con +2 diferencia (visitante o local)
      // Visitante
      if ((oGame.countAway - oGame.countHome) > 2) {
        teamGanador = 2;
        hayDifWin = true;
        maxValue = oGame.countAway;
        minValue = oGame.countHome;
      }
      // Gana Local
      if (!hayDifWin && (oGame.countHome - oGame.countAway) > 2) {
        teamGanador = 1;
        hayDifWin = true;
        maxValue = oGame.countHome;
        minValue = oGame.countAway;
      }
    }

    if (hayDifWin) {
      GameBet gameBet = new GameBet();
      gameBet.idSport = oGame.idSport;
      gameBet.date = oGame.date;
      gameBet.time = oGame.time;
      gameBet.maxValue = maxValue;
      gameBet.minValue = minValue;

      if (oGame.idSport.toLowerCase() == 'nba' ||
          oGame.idSport.toLowerCase() == 'nfl') {
        etiquetaJuego = 'sp+/-';
        gameBet.typeBet = TYPEBET.SPREAD;
      } else {
        etiquetaJuego = 'ml';
        gameBet.typeBet = TYPEBET.ML;
      }

      textoFinal = '$datoJuego $etiquetaJuego ';
      if (esSoccer) {
        switch (teamGanador) {
          case 0:
            textoFinal += "X";
            break;
          case 1:
            textoFinal += teamHome;
            break;
          case 2:
            textoFinal += teamAway;
            break;
          default:
        }
      } else {
        // US Games
        // Visitante
        if (teamGanador == 2) {
          textoFinal += teamAway;
        } else {
          textoFinal += teamHome;
        }
      }
      textoFinal += '(${maxValue.toString()}.${minValue.toString()}) | ';
      //Agregar a lista de bets
      gameBet.label = textoFinal;
      _listaBet.add(gameBet);
    }

    /////// OVER / UNDER ///////////////////////////////////////////////////////////////////////////
    if (oGame.countOverUnder.abs() > 2) {
      GameBet gameBet = new GameBet();
      gameBet.idSport = oGame.idSport;
      gameBet.date = oGame.date;
      gameBet.time = oGame.time;
      gameBet.maxValue = oGame.countOverUnder.abs();
      // MIN solo para orden sera 3y4 = 1, 5+ - 0
      if (gameBet.maxValue == 3 || gameBet.maxValue == 4) {
        gameBet.minValue = 1;
      } else {
        gameBet.minValue = 0;
      }

      gameBet.typeBet = TYPEBET.OVERUNDER;

      textoFinal = datoJuego + ' ';
      textoFinal += (oGame.countOverUnder > 0) ? 'over ' : 'under ';
      textoFinal +=
          '(${gameBet.maxValue.toString()}.${gameBet.minValue.toString()}) | ';
      //Agregar a lista de bets
      gameBet.label = textoFinal;
      _listaBet.add(gameBet);
    }

    /////// EXTRA = ML (US) / BTTS (SOCCER) ///////////////////////////////////////////////////////////////////////////
    if (oGame.countExtra.abs() > 2) {
      GameBet gameBet = new GameBet();
      gameBet.idSport = oGame.idSport;
      gameBet.date = oGame.date;
      gameBet.time = oGame.time;
      gameBet.maxValue = oGame.countExtra.abs();
      // MIN solo para orden sera 3y4 = 1, 5+ - 0
      if (gameBet.maxValue == 3 || gameBet.maxValue == 4) {
        gameBet.minValue = 1;
      } else {
        gameBet.minValue = 0;
      }

      textoFinal = datoJuego + ' ';

      if (esSoccer) {
        gameBet.typeBet = TYPEBET.BTTS;
        textoFinal += ' btts ';
        textoFinal += (oGame.countExtra > 0) ? 'Y' : 'N';
      } else {
        gameBet.typeBet = TYPEBET.ML;
        textoFinal += ' ml ';
        textoFinal += (oGame.countExtra > 0) ? teamAway : teamHome;
      }

      textoFinal +=
          '(${gameBet.maxValue.toString()}.${gameBet.minValue.toString()}) | ';
      //Agregar a lista de bets
      gameBet.label = textoFinal;
      _listaBet.add(gameBet);
    }
  }
}
