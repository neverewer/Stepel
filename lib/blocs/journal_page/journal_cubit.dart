import 'package:stepel/blocs/journal_page/journal_state.dart';
import 'package:stepel/imports.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit({required this.fitDataRepo}) : super(const JournalState.idle(data: []));

  final FitDataRepositoryImp fitDataRepo;

  void init() async {
    emit(const JournalState.processing(data: []));
    var result = await fitDataRepo.getAllFitData();
    emit(JournalState.successful(data: result));
  }
}
