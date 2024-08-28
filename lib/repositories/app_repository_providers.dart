// lib/repositories/app_repository_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_repository.dart';
import 'user_repository.dart';

MultiRepositoryProvider appRepositoryProviders(Widget child) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(
        create: (_) => AuthRepository(),
      ),
      RepositoryProvider<UserRepository>(
        create: (_) => UserRepository(),
      ),
    ],
    child: child,
  );
}
