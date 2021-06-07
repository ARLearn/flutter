import 'package:flutter/material.dart';
import 'package:youplay/models/game.dart';
import 'package:intl/intl.dart';
import 'package:youplay/screens/components/icon/game_icon.dart';



class GameInfoListTile extends StatelessWidget {

  Game game;

  Function openGame;
  GameInfoListTile({this.game, this.openGame});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMMd(Localizations.localeOf(context).languageCode);
    return ListTile(
      leading: GameIcon(game: game),
      title: Text('${game.title}'),
      subtitle: Text(
          '${formatter.format(DateTime.fromMillisecondsSinceEpoch(game.lastModificationDate))} '),
      onTap: () {
        this.openGame();
        //gameListModel.openGame(gameListModel.games[i]);
      },
      trailing: Icon(
        !game.privateMode ? Icons.lock : Icons.lock_open,
      ),
    );
  }
}
