enum eTypeBet { ML, SPREAD, OVERUNDER, BTTS }

class GameBet {
  String idSport;
  DateTime date;
  String time; // formato 24H 00:00
  eTypeBet typeBet;
  String label;
  int maxValue = 0;
  int minValue = 0;
}
