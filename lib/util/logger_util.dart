import 'package:logger/logger.dart';

/// Main logger for log information (debug, info, error, warning)
///
/// **NOTE: Only use logger, do not use [print] function**
final logger = Logger(
  printer: PrettyPrinter(
    printEmojis: true,
    methodCount: 6,
    lineLength: 10000,
  ),
);
