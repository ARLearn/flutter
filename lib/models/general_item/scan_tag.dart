import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/general_item/dependency.dart';
import 'package:youplay/ui/components/messages_pages/scan-tag.widget.container.dart';

class ScanTagGeneralItem extends GeneralItem {
  ScanTagGeneralItem({
    required int gameId,
    required int itemId,
    required bool deleted,
    required int lastModificationDate,
    required int sortKey,
    required String title,
    required String richText,
    String? icon,
    double? lat,
    double? lng,
    double? authoringX,
    double? authoringY,
    Dependency? dependsOn,
    Dependency? disappearOn,
    required bool showOnMap,
    required bool showInList,
  }) : super(
            type: ItemType.scanTag,
            gameId: gameId,
            itemId: itemId,
            description: '',
            deleted: deleted,
            lastModificationDate: lastModificationDate,
            sortKey: sortKey,
            title: title,
            richText: richText,
      icon: icon,
            dependsOn: dependsOn,
            disappearOn: disappearOn,
            showOnMap: showOnMap,
            showInList: showInList,
            authoringX: authoringX,
            authoringY: authoringY,
            lat: lat,
            lng: lng);

  factory ScanTagGeneralItem.fromJson(Map json) {
    var returnItem = ScanTagGeneralItem(
        gameId: int.parse(json['gameId']),
        itemId: int.parse(json['id']),
        deleted: json['deleted'],
        lastModificationDate: int.parse(json['lastModificationDate']),
        sortKey: json['sortKey'] ?? 0,
        title: json['name'],
        richText: json['richText'] ?? '',
        icon: json['icon'],
        lat: json['lat'],
        lng: json['lng'],
        authoringX: json['customMapX'],
        authoringY: json['customMapY'],
        showOnMap: json['showOnMap'] ?? false,
        showInList: json['showInList'] == null ? true : json['showInList'],
        dependsOn: json['dependsOn'] != null ? Dependency.fromJson(json['dependsOn']) : null,
        disappearOn: json['disappearOn'] != null ? Dependency.fromJson(json['disappearOn']) : null);
    return returnItem;
  }

  bool get isSupported {
    return !UniversalPlatform.isWeb;
  }

  String getIcon() {
    return 'fa.qrcode';
  }

  Widget buildPage() {
    return ScanTagWidgetContainer(item: this);
  }

}
