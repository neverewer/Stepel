import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';

import '../../db/database.dart';
import '../../models/fit_data.dart';
import '../local_storage_service.dart';

class PedometrServiceForeground {
  static final PedometrServiceForeground _instance = PedometrServiceForeground._internal();
  factory PedometrServiceForeground() => _instance;
  PedometrServiceForeground._internal();

  final int dayCardioPointsTarget = 40;
  int initialSteps = 0;
  final int stepTarget = 8000;
  FitData _fitData = FitData.zero;
  final DateTime currentDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final AppDb _db = AppDb();

  Stream<FitData> get fitDataStream => Pedometer.stepCountStream.asBroadcastStream().map((event) {
        _fitData = _fitData.copyWith(newSteps: event.steps - initialSteps);
        return _fitData;
      });

  Future<void> init() async {
    await getInitialSteps();
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

  Future<void> loadFitData() async {
    var steps = await _db.getStepsByDate(currentDate);
    _fitData = _fitData.copyWith(newSteps: steps.steps);
  }

  FitData getFitData() => _fitData;
}
