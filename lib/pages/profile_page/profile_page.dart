import 'package:stepel/blocs/profile_page/profile_cubit.dart';
import 'package:stepel/imports.dart';
import 'package:stepel/pages/profile_page/profile_form.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(profileDataRepo: context.read<ProfileDataRepositoryImp>())..init(),
      child: const ProfileForm(),
    );
  }
}
