import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:remindly_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    SemanticsBinding.instance.ensureSemantics();
  }
  runApp(const RemindlyApp());
}
