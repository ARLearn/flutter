import 'package:flutter/material.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/general_item/dependency.dart';
import 'package:youplay/ui/components/messages_pages/single-choice-image.widget.container.dart';

import 'multiple_choice_image.dart';

class SingleChoiceImageGeneralItem extends GeneralItem {
  List<ImageChoiceAnswer> answers = [];
  bool showFeedback;
  String text;

  SingleChoiceImageGeneralItem({
    required int gameId,
    required int itemId,
    required bool deleted,
    required int lastModificationDate,
    required int sortKey,
    required String title,
    required this.text,
    required this.showFeedback,
    required String richText,
    String? icon,
    required String description,
    required this.answers,
    Dependency? dependsOn,
    Dependency? disappearOn,
    Map<String, String>? fileReferences,
    Color? primaryColor,
    double? lat,
    double? lng,
    double? authoringX,
    double? authoringY,
    int? chapter,
    required bool showOnMap,
    required bool showInList,
  }) : super(
            type: ItemType.singlechoiceimage,
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

  String getIcon() {
    return icon ?? 'fa.image';
  }

  Widget buildPage() {
    return SingleChoiceImageWidgetContainer(item: this);
  }

  factory SingleChoiceImageGeneralItem.fromJson(Map json) {
//    print("json image single choice ${json}");
//    print("json image single choice ${json['showFeedback']}");
    var returnItem = SingleChoiceImageGeneralItem(
        gameId: int.parse(json['gameId']),
        itemId: int.parse(json['id']),
        deleted: json['deleted'],
        lastModificationDate: int.parse(json['lastModificationDate']),
        sortKey: json['sortKey'] ?? 0,
        title: json['name'],
        richText: json['richText'] ?? '',
        icon: json['icon'],
        description: (json['description'] ?? "").trim(),
        text: json['text'] ?? '',
        showFeedback: json['showFeedback'] == null ? false : json['showFeedback'],
        answers: json['answers'] == null
            ? []
            : List<ImageChoiceAnswer>.generate(
                json['answers'].length, (i) => ImageChoiceAnswer.fromJson(json['answers'][i])),
        showOnMap: json['showOnMap'] ?? false,
        showInList: json['showInList'] == null ? true : json['showInList'],
        lat: json['lat'],
        lng: json['lng'],
        authoringX: json['customMapX'],
        authoringY: json['customMapY'],
        chapter: json['chapter'] == null ? null : int.parse(json['chapter']),
        fileReferences: json['fileReferences'] != null
            ? new Map.fromIterable(json["fileReferences"],
                key: (item) => item['key'], value: (item) => item['fileReference'] ?? '')
            : null,
        primaryColor: json['primaryColor'] != null ? colorFromHex(json['primaryColor']) : null,
        dependsOn: json['dependsOn'] != null ? Dependency.fromJson(json['dependsOn']) : null,
        disappearOn: json['disappearOn'] != null ? Dependency.fromJson(json['disappearOn']) : null);
    return returnItem;
  }
}

Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
