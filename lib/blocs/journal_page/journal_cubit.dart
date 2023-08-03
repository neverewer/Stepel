import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/journal_page/journal_state.dart';
import 'package:stepel/repositories/fit_data_repository.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit({required this.fitDataRepo}) : super(const JournalState.idle(data: null));

  final FitDataRepositoryImp fitDataRepo;

  void loadFitData() async {
    emit(const JournalState.processing(data: null));
    var result = await fitDataRepo.getAllFitData();
    emit(JournalState.successful(data: result));
  }
}
