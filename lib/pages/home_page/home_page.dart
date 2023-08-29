import 'package:stepel/imports.dart';
import 'package:stepel/blocs/home_page/home_cubit.dart';
import 'package:stepel/pages/home_page/home_page_form.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(
              fitDataRepo: context.read<FitDataRepositoryImp>(),
              profileDataRepo: context.read<ProfileDataRepositoryImp>(),
            )..init(),
        child: const HomePageForm());
  }
}
