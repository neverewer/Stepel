import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';

import '../../db/database.dart';
import '../../models/fit_data.dart';
import '../local_storage_service.dart';

class PedometrServiceForeground {
  static final PedometrServiceForeground _instance = PedometrServiceForeground._internal();
  factory PedometrServiceForeground() => _instance;
  PedometrServiceForeground._internal();

  final int _cardioPointsTarget = 40;
  int initialSteps = 0;
  final int _stepTarget = 8000;
  FitData _fitData = FitData.zero;
  DateTime currentDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  List<FitData> _weeklyFitData = [];
  final AppDb _db = AppDb();

  Stream<FitData> get fitDataStream => Pedometer.stepCountStream.asBroadcastStream().map((event) => stepCount(event));

  Future<void> init() async {
    await getInitialSteps();
    await getCurrentDate();
    await loadFitData();
  }

  Future<void> getInitialSteps() async {
    var initSteps = await LocalStorageService.instance.getCurrentSteps();
    //if initial steps have not been saved in SharedPreferences, we exit the function
    if (initSteps == null) {
      return;
    }
    initialSteps = initSteps;
  }

  Future<void> getCurrentDate() async {
    var date = await LocalStorageService.instance.getStepDate();
    date != null
        ? currentDate = DateTime.parse(date)
        : LocalStorageService.instance.setStepDate(currentDate.toIso8601String());
  }

  Future<void> loadFitData() async {
    var result = _db.getStepsByDate(currentDate);
    var steps = await result.getSingleOrNull();
    if (steps != null) {
      _fitData = _fitData.copyWith(newSteps: steps.steps);
    }
  }

  FitData stepCount(StepCount event) {
    checkInitialSteps(event);
    checkCurrentDate(event);
    _fitData = _fitData.copyWith(newSteps: event.steps - initialSteps);
    return _fitData;
  }

  void checkInitialSteps(StepCount event) {
    if (initialSteps != 0) {
      return;
    }
    initialSteps = event.steps;
  }

  void checkCurrentDate(StepCount event) {
    if (currentDate.day == event.timeStamp.day) {
      return;
    }
    initialSteps == event.steps;
  }

  FitData getFitData() => _fitData;

  int getStepsTarget() => _stepTarget;

  int getCardioPointsTarget() => _cardioPointsTarget;

  Future<List<List<double>>> getWeeklyData() async {
    var result = await _db.getWeeklySteps();
    _weeklyFitData = result.map((step) => FitData(step.steps)).toList();
    var weeklySteps = _weeklyFitData.map((e) => e.steps.toDouble()).toList();
    var weeklyCalories = _weeklyFitData.map((e) => e.calories).toList();
    var weeklyCardioPoints = _weeklyFitData.map((e) => e.cardioPoints.toDouble()).toList();
    return [weeklySteps, weeklyCardioPoints, weeklyCalories];
  }

  Future<List<FitData>> loadGeneralFitData() async {
    var result = await _db.getAllSteps();
    var list = result.reversed.map((e) => FitData(e.steps, date: e.date)).toList();
    return list;
  }
}
