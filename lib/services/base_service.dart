import 'package:logging/logging.dart';
import 'package:my_event_tracker/utils/logger.dart';

abstract class BaseService {
  static const String baseUrl = 'http://10.0.2.2:9095';
  //static const String baseUrl = 'http://192.168.1.63:9095';
  final String _serviceName;

  BaseService(String name) : _serviceName = name;

  void logInfo(String message) => AppLogger.info(message);
  void logFine(String message) => AppLogger.fine(message);
  void logWarning(String message) => AppLogger.warning(message);
  void logSevere(String message, [Object? error, StackTrace? stackTrace]) => 
      AppLogger.severe(message, error, stackTrace);

  Logger get serviceName => Logger(_serviceName);
} 