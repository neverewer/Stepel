import 'package:stepel/blocs/journal_page/journal_cubit.dart';
import 'package:stepel/imports.dart';
import 'package:stepel/pages/journal_page/journal_form.dart';

@RoutePage()
class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JournalCubit(fitDataRepo: context.read<FitDataRepositoryImp>())..init(),
      child: const JournalForm(),
    );
  }
}
