import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/journal_page/journal_cubit.dart';
import 'package:stepel/pages/journal_page/journal_form.dart';

@RoutePage()
class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JournalCubit()..loadFitData(),
      child: const JournalForm(),
    );
  }
}
