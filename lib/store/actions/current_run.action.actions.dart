import 'package:flutter/material.dart';
import 'package:youplay/models/run.dart';


class LocalAction {
  String action;
  int runId;
  int? generalItemId;
  final int timeStamp = DateTime.now().millisecondsSinceEpoch;

  LocalAction({required this.action, required this.runId, this.generalItemId});

  ARLearnAction getAction() {
    return new ARLearnAction(
        runId: runId,
        action: action,
        generalItemId: generalItemId,
        timestamp: this.timeStamp);
  }

  notConsumed() {

  }
}

class ReadItemAction extends LocalAction {
  ReadItemAction({required int runId, required int generalItemId})
      : super(action: "read", runId: runId, generalItemId: generalItemId);
}

class QrScannerAction extends LocalAction {

  final BuildContext context;
  QrScannerAction(
      {required this.context,  required int runId, required int generalItemId, required String qrCode})
      : super(action: qrCode, runId: runId, generalItemId: generalItemId);

  notConsumed() {
    const snackBar = SnackBar(
      content: Text('Deze code werd reeds gescand! '),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class MultipleChoiceAnswerAction extends LocalAction {
  MultipleChoiceAnswerAction(
      {required int runId,
      required int generalItemId,
      required String answerId})
      : super(
            action: 'answer_$answerId',
            runId: runId,
            generalItemId: generalItemId);
}

class AnswerCorrect extends LocalAction {
  AnswerCorrect({required int runId, required int generalItemId})
      : super(
            action: 'answer_correct',
            runId: runId,
            generalItemId: generalItemId);
}

class AnswerWrong extends LocalAction {
  AnswerWrong({required int runId, required int generalItemId})
      : super(
            action: 'answer_incorrect',
            runId: runId,
            generalItemId: generalItemId);
}

class Complete extends LocalAction {
  Complete({required int runId, required int generalItemId})
      : super(action: 'complete', runId: runId, generalItemId: generalItemId);
}

class LocationAction extends LocalAction {

  LocationAction(
      {required double lat,
      required double lng,
      required int radius,
      required int runId})
      : super(runId: runId, action: "geo:$lat:$lng:$radius");
}
