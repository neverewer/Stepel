import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocks/home_page/home_page_state.dart';
import 'package:stepel/services/pedometr_service/pedometr_service_foreground.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(InitialHomePageState()) {
    init();
  }

  final PedometrServiceForeground pedometrService = PedometrServiceForeground();

  void init() {
    initPedometrSubscription();
    loadFitData();
  }

  void initPedometrSubscription() {
    pedometrService.fitDataStream.listen((event) => emit((state as LoadedHomePageState).copyWith(fitData: event)));
  }

  void loadFitData() {
    emit(LoadedHomePageState(
        fitData: pedometrService.getFitData(),
        dayCardioPointsTarget: pedometrService.dayCardioPointsTarget,
        stepTarget: pedometrService.stepTarget));
  }
}
