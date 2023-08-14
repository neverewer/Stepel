import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepel/blocs/profile_page/profile_cubit.dart';
import 'package:stepel/pages/profile_page/profile_form.dart';
import 'package:stepel/repositories/profile_data_repository.dart';

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
