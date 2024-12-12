import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService(ref)); 