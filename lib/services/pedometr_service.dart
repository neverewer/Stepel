import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

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
  int walkingTimeInSeconds = 0;
  int preStepCount = 0;
  int stepTarget = 8000;

  StreamController<List<Object>> dataStream = StreamController<List<Object>>();

  late StreamSubscription<StepCount> _stepCountSubscription;

  Future init() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountSubscription = Pedometer.stepCountStream.listen((StepCount event) {
        if (preStepCount == 0) {
          preStepCount = event.steps;
        }
        stepCount = event.steps - preStepCount;
        calories = stepCount * 0.04;
        distance = stepCount * 0.0008;
        dataStream.add([stepCount, calories, distance]);
      });
    }
  }

  // double getValue(double x, double y, double z) {
  //   double magnitude = sqrt(x * x + y * y + z * z);
  //   getPreviousValue();
  //   double modDistance = magnitude - preValue;
  //   setPreviousValue(modDistance);
  //   return modDistance;
  // }

  // void setPreviousValue(double distance) async {
  //   var _prefs = await SharedPreferences.getInstance();
  //   _prefs.setDouble('preValue', distance);
  // }

  // void getPreviousValue() async {
  //   var _prefs = await SharedPreferences.getInstance();
  //   preValue = _prefs.getDouble('preValue') ?? 0.0;
  // }

  // void stopCountingSteps() {
  //   stopStepCounting();
  //   stopWalkingTimeCounting();
  //   _pedestrianStatusSubscription.cancel();
  // }

  // void startStepCounting() {
  //   _stepCountSubscription = Pedometer.stepCountStream.listen((StepCount event) {
  //     stepCount = event.steps;
  //     calories = stepCount * 0.04;
  //     distance = stepCount * 0.0008;
  //   });
  // }

  // void stopStepCounting() {
  //   _stepCountSubscription.cancel();
  // }

//   void startDistanceCounting() {
// _positionSubscription = Geolocator.getPositionStream().listen((Position position) {
//       Geolocator.distanceBetween(
//           position.latitude,
//           position.longitude,
//           position.latitude,
//           position.longitude,
//         ).then((double calculatedDistance) {
//           distance += calculatedDistance;
//         });
//     });
//   }

  // void stopDistanceCounting() {
  //   _distanceSubscription.cancel();
  // }

  // void startCaloriesCounting() {
  //   _stepCountSubscription = Pedometer.stepCountStream.listen((int steps) {
  //     calories = steps * 0.04; // Примерный расчет калорий на основе количества шагов
  //   });
  // }

  // void stopCaloriesCounting() {
  //   _stepCountSubscription?.cancel();
  //   _stepCountSubscription = null;
  // }

  // void startWalkingTimeCounting() {
  //   _positionSubscription = Geolocator.getPositionStream().listen((Position position) {
  //     if (position.speed > 0) {
  //       walkingTimeInSeconds++;
  //     }
  //   });
  // }

  // void stopWalkingTimeCounting() {
  //   _positionSubscription.cancel();
  // }
}
