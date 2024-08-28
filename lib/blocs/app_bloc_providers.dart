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
    ],
    child: child,
  );
}
