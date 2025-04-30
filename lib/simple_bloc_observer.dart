import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('change = $change');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('change = $bloc');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('change = $bloc');
  }
}
