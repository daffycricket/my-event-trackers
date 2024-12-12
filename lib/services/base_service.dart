import 'package:logging/logging.dart';

abstract class BaseService {
  static const String baseUrl = 'http://10.0.2.2:9095';
  final Logger _logger;

  BaseService(String name) : _logger = Logger(name);

  // Méthodes utilitaires pour les logs
  void logInfo(String message) => _logger.info(message);
  void logFine(String message) => _logger.fine(message);
  void logWarning(String message) => _logger.warning(message);
  void logSevere(String message, [Object? error, StackTrace? stackTrace]) => 
      _logger.severe(message, error, stackTrace);
} 