import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/home_page/home_cubit.dart';
import 'package:stepel/pages/home_page/home_page_form.dart';
import 'package:stepel/repositories/fit_data_repository.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(fitDataRepo: context.read<FitDataRepositoryImp>())..init(),
        child: const HomePageForm());
  }
}
