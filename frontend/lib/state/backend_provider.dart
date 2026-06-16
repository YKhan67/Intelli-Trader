import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

enum ConnectionStatus { connected, disconnected, connecting }

final backendConnectionProvider = StateProvider<ConnectionStatus>((ref) => ConnectionStatus.disconnected);
