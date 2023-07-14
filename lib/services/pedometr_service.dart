import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepel/services/local_storage_service.dart';

class PedometrService {
  static PedometrService? instance;

  PedometrService._();

  static PedometrService getInstance() {
    instance ??= PedometrService._();
    return instance!;
  }

  int stepCount = 0;
  double distance = 0.0;
  double calories = 0.0;
  int cardioPoints = 0;
  int dayCardioPointsTarget = 40;
  int walkingTimeInSeconds = 0;
  int preStepCount = 0;
  int stepTarget = 8000;

  StreamController<List<Object>> dataStream = StreamController<List<Object>>();

  Future init() async {
    if (await Permission.activityRecognition.request().isGranted) {
      await getPreviousSteps();
      Pedometer.stepCountStream.listen(onStepCount).onError(onStepCountError);
    }
  }

  Future getPreviousSteps() async {
    var preSteps = (await LocalStorageService.instance.getCurrentSteps());
    if (preSteps != null) {
      preStepCount = preSteps;
    }
  }

  void setPreviousSteps(StepCount event) {
    if (preStepCount == 0) {
      preStepCount = event.steps;
      LocalStorageService.instance.setCurrentSteps(preStepCount);
    }
  }

  void updateFitData(StepCount event) {
    stepCount = event.steps - preStepCount;
    calories = stepCount * 0.04;
    distance = stepCount * 0.0007;
    cardioPoints = (stepCount * 0.005).toInt();
    notifyUpdateFitData([stepCount, calories, distance, cardioPoints]);
  }

  void notifyUpdateFitData(List<Object> list) => dataStream.add(list);

  void onStepCount(StepCount event) {
    //var p = event.timeStamp;
    setPreviousSteps(event);
    updateFitData(event);
  }

  void onStepCountError(error) {}
}
