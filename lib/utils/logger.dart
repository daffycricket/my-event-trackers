import 'package:logging/logging.dart';
import 'dart:convert';

class AppLogger {
  static final Logger _logger = Logger('AppLogger');
  static const _prettyEncoder = JsonEncoder.withIndent('  ');

  static String _formatMessage(dynamic message) {
    if (message is Map || message is List) {
      // Formater Map ou List directement
      try {
        return '\n${_prettyEncoder.convert(message)}';
      } catch (e) {
        return message.toString();
      }
    } else if (message is String) {
      // Tenter de parser un JSON String
      try {
        final dynamic decoded = json.decode(message);
        if (decoded is Map || decoded is List) {
          return '\n${_prettyEncoder.convert(decoded)}';
        }
      } catch (_) {
        // Si ce n'est pas un JSON valide, retourner la chaîne originale
      }
    }
    return message.toString(); // Retour par défaut
  }

  static void info(dynamic message) {
    _logger.info(_formatMessage(message));
  }

  static void fine(dynamic message) {
    _logger.fine(_formatMessage(message));
  }

  static void warning(dynamic message) {
    _logger.warning(_formatMessage(message));
  }

  static void severe(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(_formatMessage(message), error, stackTrace);
  }
}