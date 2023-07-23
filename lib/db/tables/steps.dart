import 'package:drift/drift.dart';

class Steps extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get steps => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
