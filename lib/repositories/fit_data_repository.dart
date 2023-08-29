import 'package:intl/intl.dart';
import 'package:stepel/db/database.dart';
import 'package:stepel/imports.dart';

abstract class FitDataRepository {
  Stream<FitData> get fitDataStream;
  Future<FitData> getCurrentFitData();
  Future<Map<String, List<double>>> getWeeklyData();
  Future<List<FitData>> getAllFitData();
}

class FitDataRepositoryImp implements FitDataRepository {
  final int _cardioPointsTarget = 40;
  final int _stepTarget = 8000;
  final AppDb _db = AppDb();
  DateTime currentDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  @override
  Stream<FitData> get fitDataStream =>
      FlutterBackgroundService().on('updateSteps').asBroadcastStream().map((event) => FitData(event!['steps']));

  int getStepsTarget() => _stepTarget;

  int getCardioPointsTarget() => _cardioPointsTarget;

  @override
  Future<FitData> getCurrentFitData() async {
    var result = _db.getStepsByDate(currentDate);
    var steps = await result.getSingleOrNull();
    if (steps != null) {
      return FitData(steps.steps);
    }
    return FitData.zero;
  }

  @override
  Future<Map<String, List<double>>> getWeeklyData() async {
    var result = await _db.getWeeklySteps();
    List<double> weeklySteps = [];
    List<double> weeklyCalories = [];
    List<double> weeklyCardioPoints = [];
    if (result.isEmpty) {
      weeklySteps = getEmptyList();
      weeklyCalories = getEmptyList();
      weeklyCardioPoints = getEmptyList();
    } else {
      var weeklyFitData = result.map((step) => FitData(step.steps)).toList();
      weeklySteps = weeklyFitData.map((e) => e.steps.toDouble()).toList();
      weeklyCalories = weeklyFitData.map((e) => e.calories).toList();
      weeklyCardioPoints = weeklyFitData.map((e) => e.cardioPoints.toDouble()).toList();
    }
    return {'steps': weeklySteps, 'cardioPoints': weeklyCardioPoints, 'calories': weeklyCalories};
  }

  @override
  Future<List<FitData>> getAllFitData() async {
    var result = await _db.getAllSteps();
    var list = result.reversed.map((e) => FitData(e.steps, date: e.date)).toList();

    if (list.isEmpty) {
      list.add(FitData(0, date: currentDate));
    }
    return list;
  }

  List<double> getEmptyList() {
    return [0, 0, 0, 0, 0, 0, 0];
  }
}
