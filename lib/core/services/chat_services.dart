import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentorme/global/global.dart';

class ChatService {
  static final String _baseUrl =
      'https://widgets22-catb7yz54a-et.a.run.app/api/chat';

  static Future<Map<String, dynamic>> getChatHistory() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      final historyData = json.decode(response.body);

      if (response.statusCode == 200 && historyData['data'] != null) {
        return historyData['data'];
      } else {
        throw Exception('Failed to load chat history');
      }
    } catch (e) {
      throw Exception('Failed to load chat history: $e');
    }
  }

  static Future<int> startNewChat(String emailMentor) async {
    try {
      final postResponse = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': emailMentor}),
      );

      final postData = json.decode(postResponse.body);

      if ((postResponse.statusCode == 200 || postResponse.statusCode == 201) &&
          postData['data'] != null) {
        // Ensure 'idRoom' is returned as an int, if it's a string, convert it
        final idRoom =
            postData['data']['idRoom']; // Assuming the idRoom is in 'data'
        if (idRoom is int) {
          return idRoom;
        } else if (idRoom is String) {
          return int.tryParse(idRoom) ??
              0; // If it's a string, try to parse it to an int
        } else {
          throw Exception('idRoom is not a valid type');
        }
      } else {
        throw Exception(postData['error'] ?? 'Failed to start new chat');
      }
    } catch (e) {
      throw Exception('Failed to start new chat: $e');
    }
  }
}
