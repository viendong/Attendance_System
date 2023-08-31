import 'package:flutter/cupertino.dart';
import 'package:flutter_config/flutter_config.dart';

class Config {
  // Private Constructor
  Config();
  static Config _instance = Config();
  static Config get instance => _instance;

  // An instance of all environment variables
  late Map<String, dynamic> _variables;

  // Instance of Config

  Future<void> loadEnvVariables() async {
    await FlutterConfig.loadEnvVariables();
    instance._variables = FlutterConfig.variables;
  }

  // Returns a specific variable value give a [key]
  dynamic get(String key) {
    var variables = instance._variables;

    if (variables.isNotEmpty && variables.containsKey(key)) {
      return variables[key];
    }

    return null;
  }

  // Returns a specific variable value give a [key]
  dynamic set(String key, dynamic value) {
    instance._variables[key] = value;
  }

  /// returns all the current loaded variables;
  Map<String, dynamic> get variables =>
      Map<String, dynamic>.of(instance._variables);

  @visibleForTesting
  void loadValueForTesting(Map<String, dynamic> values) {
    instance._variables = values;
  }

  bool isEmpty(String key) {
    return instance.get(key) == null || instance.get(key).toString().isEmpty;
  }
}
