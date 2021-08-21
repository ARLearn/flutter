import 'package:flutter/material.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/screens/components/game_play/message_list_entry.dart';

class MessagesList extends StatelessWidget {

  final List<ItemTimes> items;
  final Function tapEntry;
  MessagesList({required this.items, required this.tapEntry});

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 2,
        color: colorFromHex('#D2DAE2'),
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          new MessageListEntry(
              item: items[i].generalItem,
              onEntryTap: () {
                this.tapEntry(items[i].generalItem);
              }, appearTime: items[i].appearTime)
        ],
      ),
    );
  }
}
