import 'dart:async';
import 'dart:developer';
import 'package:ai_image_generator/components/components.dart';
import 'package:ai_image_generator/helper/environment/environment.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Initializer {
  static void init(VoidCallback runApp) {
    ErrorWidget.builder = (errorDetails) {
      return CustomErrorWidget(message: errorDetails.exceptionAsString(),
      );
    };

    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (details) {
        FlutterError.dumpErrorToConsole(details);
        log(details.stack.toString());
      };

      await _initServices();
      runApp();
    }, (error, stack) {
      log('runZonedGuarded: ${error.toString()}');
    });
  }

  static Future<void> _initServices() async {
    try {

      await _loadEnv();

      _initScreenPreference();
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> _loadEnv () async {
    await dotenv.load(fileName: Environment.fileName);
  }


  static void _initScreenPreference() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}