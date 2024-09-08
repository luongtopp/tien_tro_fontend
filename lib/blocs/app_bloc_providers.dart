import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_blocs.dart';
import 'package:chia_se_tien_sinh_hoat_tro/repositories/group_repository.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import 'auth_bloc/auth_blocs.dart';
import 'group_bloc/group_stream_blocs.dart';
import 'onboarding_bloc/onboarding_blocs.dart';

MultiBlocProvider appBlocProviders(BuildContext context, Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<OnBoardingBloc>(
        create: (context) => OnBoardingBloc(),
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          userRepository: RepositoryProvider.of<UserRepository>(context),
          groupRepository: RepositoryProvider.of<GroupRepository>(context),
        ),
        child: const LoginScreen(),
      ),
      BlocProvider<GroupBloc>(
        create: (context) => GroupBloc(
          groupRepository: RepositoryProvider.of<GroupRepository>(context),
          userRepository: RepositoryProvider.of<UserRepository>(context),
        ),
      ),
      BlocProvider<GroupStreamBloc>(
        create: (context) => GroupStreamBloc(
          groupRepository: RepositoryProvider.of<GroupRepository>(context),
        ),
      ),
      BlocProvider<GroupStreamBloc>(
        create: (context) => GroupStreamBloc(
          groupRepository: RepositoryProvider.of<GroupRepository>(context),
        ),
      ),
    ],
    child: child,
  );
}
