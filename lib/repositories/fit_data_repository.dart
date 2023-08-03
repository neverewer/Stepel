import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';

import '../db/database.dart';
import '../models/fit_data.dart';

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
    var weeklyFitData = result.map((step) => FitData(step.steps)).toList();
    var weeklySteps = weeklyFitData.map((e) => e.steps.toDouble()).toList();
    var weeklyCalories = weeklyFitData.map((e) => e.calories).toList();
    var weeklyCardioPoints = weeklyFitData.map((e) => e.cardioPoints.toDouble()).toList();
    return {'steps': weeklySteps, 'cardioPoints': weeklyCardioPoints, 'calories': weeklyCalories};
  }

  @override
  Future<List<FitData>> getAllFitData() async {
    var result = await _db.getAllSteps();
    var list = result.reversed.map((e) => FitData(e.steps, date: e.date)).toList();
    return list;
  }
}
