import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/journal_page/journal_state.dart';
import 'package:stepel/services/pedometr_service/pedometr_service_foreground.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit() : super(const JournalState.idle(data: null));

  final PedometrServiceForeground pedometrService = PedometrServiceForeground();

  void loadFitData() async {
    emit(const JournalState.processing(data: null));
    var result = await pedometrService.loadGeneralFitData();
    emit(JournalState.successful(data: result));
  }
}
