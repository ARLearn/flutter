import 'package:flutter/material.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/general_item/dependency.dart';
import 'package:youplay/models/general_item/single_choice.dart';
import 'package:youplay/ui/components/messages_pages/combination-lock.widget.container.dart';

import '../game.dart';

class CombinationLockGeneralItem extends GeneralItem {
  List<ChoiceAnswer> answers = [];
  bool showFeedback;
  String text;

  CombinationLockGeneralItem({
    required int gameId,
    required int itemId,
    required bool deleted,
    required int lastModificationDate,
    required int sortKey,
    required String title,
    required this.text,
    required this.showFeedback,
    String? icon,
    required String richText,
    required String description,
    required this.answers,
    Dependency? dependsOn,
    Dependency? disappearOn,
    Color? primaryColor,
    Map<String, String>? fileReferences,
    double? lat,
    double? lng,
    double? authoringX,
    double? authoringY,
    int? chapter,
    required bool showOnMap,
    required bool showInList,
  }) : super(
            type: ItemType.combinationlock,
            gameId: gameId,
            itemId: itemId,
            deleted: deleted,
            lastModificationDate: lastModificationDate,
            sortKey: sortKey,
            title: title,
            richText: richText,
            icon: icon,
            description: description,
            dependsOn: dependsOn,
            disappearOn: disappearOn,
            fileReferences: fileReferences,
            primaryColor: primaryColor,
            showOnMap: showOnMap,
            showInList: showInList,
            authoringX: authoringX,
            authoringY: authoringY,
            chapter: chapter,
            lat: lat,
            lng: lng);

  factory CombinationLockGeneralItem.fromJson(Map json) {
    var returnItem = CombinationLockGeneralItem(
        gameId: int.parse(json['gameId']),
        itemId: int.parse(json['id']),
        deleted: json['deleted'],
        lastModificationDate: int.parse(json['lastModificationDate']),
        sortKey: json['sortKey'] ?? 0,
        title: json['name'],
        text: json['text'] ?? '',
        showFeedback: json['showFeedback'] == null ? false : json['showFeedback'],
        richText: json['text'] ?? '',
        icon: json['icon'],
        description: (json['description'] ?? "").trim(),
        answers: json['answers'] == null
            ? []
            : List<ChoiceAnswer>.generate(json['answers'].length, (i) => ChoiceAnswer.fromJson(json['answers'][i])),
        showOnMap: json['showOnMap'] ?? false,
        showInList: json['showInList'] == null ? true : json['showInList'],
        lat: json['lat'],
        lng: json['lng'],
        chapter: json['chapter'] == null ? null : int.parse(json['chapter']),
        authoringX: json['customMapX'],
        authoringY: json['customMapY'],
        fileReferences: json['fileReferences'] != null
            ? new Map.fromIterable(json["fileReferences"],
                key: (item) => item['key'], value: (item) => item['fileReference'] ?? '')
            : {},
        primaryColor: json['primaryColor'] != null ? colorFromHex(json['primaryColor']) : null,
        dependsOn: json['dependsOn'] != null ? Dependency.fromJson(json['dependsOn']) : null,
        disappearOn: json['disappearOn'] != null ? Dependency.fromJson(json['disappearOn']) : null);
    return returnItem;
  }

  String getIcon() {
    return icon ?? 'fa.unlock';
  }

  Widget buildPage() {
    return CombinationLockWidgetContainer(item: this);
  }
}
