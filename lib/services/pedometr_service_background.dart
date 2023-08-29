import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:stepel/db/database.dart' as db;
import 'package:stepel/imports.dart';

class PedometrServiceBackground {
  //service to show notifications

  // initial Pedometr steps count
  // due to the fact that the pedometer gives the current number of steps, we need to remember the initial number of steps when we first start the application
  static int _initialSteps = 0;

  static int _stepTarget = 0;

  static int _steps = 0;

  static final LocalStorageService _localStorageService = LocalStorageService.instance;

  // database
  static final db.AppDb _db = db.AppDb();

  //current date in the format yyyy-mm-dd
  // this format is needed to remove the time from the date in order to correctly update the steps in the database
  static DateTime currentDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  // android configuration for background service
  static final AndroidConfiguration _androidConfiguration = AndroidConfiguration(
    onStart: onStart,
    autoStart: true, // automatically start background service after configure
    isForegroundMode: false,
    autoStartOnBoot: true, // automatically start service when device on boot
  );

  //function to initialize service in background
  static void init() async {
    //getAllSteps();
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      return;
    }
    await service.configure(androidConfiguration: _androidConfiguration, iosConfiguration: IosConfiguration());
  }

  // static void getAllSteps() async {
  //   List<Step> steps = await _db.getAllSteps();
  //   print(currentDate);
  //   print(currentDate.microsecondsSinceEpoch);
  //   for (int i = 0; i < steps.length; i++) {
  //     print('dateInMillseconds: ${steps[i].date.millisecondsSinceEpoch}');
  //     print('${steps[i].date}');
  //     print(steps[i].date.millisecondsSinceEpoch == currentDate.millisecondsSinceEpoch);
  //   }
  // }

  // this function will be executed when app is in foreground or background in separated isolate
  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    var stepsTar = await _localStorageService.getStepsTarget() ?? 8000;
    _stepTarget = stepsTar;
    await getInitialSteps();
    await getCurrentDate();
    service.on('ChangeStepTarget').listen((event) {
      if (event == null) {
        return;
      }
      NotificationService.showOrUpdateFitNotification(_steps, event['stepTarget']);
    });
    Pedometer.stepCountStream.listen((event) => onStepCount(event, service)).onError(onStepCountError);
  }

  // function for counting steps
  static void onStepCount(StepCount event, ServiceInstance service) {
    setInitialSteps(event);
    if (event.timeStamp.day == currentDate.day) {
      // if the current day coincides with the date the steps were received, then we save the current steps to database
      saveStepsToDatabase(event);
    } else {
      // if the current day does not coincide with the date of receipt of the steps, we update current date and initial steps
      updateCurrentDate();
      updateInitialSteps(event.steps);
    }
    service.invoke('updateSteps', {'steps': event.steps - _initialSteps});
  }

  // function to handle error while listening Pedometr.stepCountStream
  static void onStepCountError(error) {}

  //get initial steps from SharedPreferences
  static Future<void> getInitialSteps() async {
    var initSteps = await _localStorageService.getCurrentSteps();
    //if initial steps have not been saved in SharedPreferences, we exit the function
    if (initSteps == null) {
      return;
    }
    _initialSteps = initSteps;
  }

  //get current date from SharedPreferences or save current date if not saved
  static Future<void> getCurrentDate() async {
    var date = await _localStorageService.getStepDate();
    date != null ? currentDate = DateTime.parse(date) : _localStorageService.setStepDate(currentDate.toIso8601String());
  }

  // save initial steps count to SharedPreferences
  // it's need if we don't have saved inital steps count value
  static void setInitialSteps(StepCount event) async {
    if (_initialSteps != 0) {
      return;
    }
    _initialSteps = event.steps;
    _localStorageService.setCurrentSteps(_initialSteps);
  }

  //update previous steps and save value to SharedPreferences
  static void updateInitialSteps(int preSteps) async {
    _localStorageService.setCurrentSteps(preSteps);
    _initialSteps = preSteps;
  }

  // update current date and save value to SharedPreferences
  static void updateCurrentDate() async {
    currentDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _localStorageService.setStepDate(currentDate.toIso8601String());
  }

  // save steps count to database
  // the database entry looks like [date - steps count]
  static void saveStepsToDatabase(StepCount event) async {
    _steps = event.steps - _initialSteps;
    _db.createOrUpdateSteps(db.Step(date: currentDate, steps: _steps));
    NotificationService.showOrUpdateFitNotification(event.steps - _initialSteps, _stepTarget);
  }
}
