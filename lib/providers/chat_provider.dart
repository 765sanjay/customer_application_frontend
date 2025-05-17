import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/api/chat/get_all_chats.dart';

import '../models/chat_models/chat_message.dart';
import '../models/chat_models/dashboard_model.dart';

final chatApiProvider = Provider<ChatGetAPIService>((ref) => ChatGetAPIService());

final chatProvider = FutureProvider.family<List<Message>, String>((ref, otherid) async {
  final apiService = ref.watch(chatApiProvider);
  return await apiService.fetchChats(otherid);
});

final chatProvider2 = FutureProvider<List<ChatDashboard>>((ref) async {
  final apiService = ref.watch(chatApiProvider);
  return await apiService.fetchChats2();
});

final nameProvider = FutureProvider<String>((ref) async {
  final apiService = ref.watch(chatApiProvider);
  return await apiService.fetchName();
});