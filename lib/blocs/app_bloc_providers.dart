import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_bloc.dart';
import 'package:chia_se_tien_sinh_hoat_tro/repositories/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import 'forgot_password_bloc/forgot_password_blocs.dart';
import 'login_bloc/login_blocs.dart';
import 'onboarding_bloc/onboarding_blocs.dart';
import 'register_bloc/register_blocs.dart';

MultiBlocProvider appBlocProviders(BuildContext context, Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<OnBoardingBloc>(
        create: (context) => OnBoardingBloc(),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          userRepository: RepositoryProvider.of<UserRepository>(context),
          groupRepository: RepositoryProvider.of<GroupRepository>(context),
        ),
      ),
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          userRepository: RepositoryProvider.of<UserRepository>(context),
        ),
      ),
      BlocProvider<ForgotPasswordBloc>(
        create: (context) => ForgotPasswordBloc(),
      ),
      BlocProvider<GroupBloc>(
        create: (context) => GroupBloc(
          groupRepository: RepositoryProvider.of<GroupRepository>(context),
        ),
      ),
    ],
    child: child,
  );
}
