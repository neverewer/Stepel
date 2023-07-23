import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/steps.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Steps])
class AppDb extends _$AppDb {
  // we tell the database where to store the data with this constructor
  AppDb() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  // Future<List<Step>> getWeeklyStepList() async {
  //   final weekAgo = DateTime.now().subtract(const Duration(days: 7));
  //   return await (select(steps)..where((tbl) => tbl.date.isBiggerOrEqualValue(weekAgo))).get();
  // }

  Future<void> createOrUpdateSteps(Step step) async {
    into(steps).insertOnConflictUpdate(step);
  }

  Future<Step> getStepsByDate(DateTime date) async {
    return await (select(steps)..where((tbl) => tbl.date.equals(date))).getSingle();
  }

  Future<List<Step>> getAllSteps() async => await (select(steps).get());

  Future<int> deleteAllData() async => await delete(steps).go();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'steps.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
