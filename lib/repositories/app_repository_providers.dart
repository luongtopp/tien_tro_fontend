import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_repository.dart';
import 'group_repository.dart';
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
      RepositoryProvider<GroupRepository>(
        create: (_) => GroupRepository(),
      ),
    ],
    child: child,
  );
}
