import 'package:empathy_virtual_assistant/apis/api_keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {

  Future<String> getResponse(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions'); // Use the appropriate endpoint for chat completions
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo', // or the model you are using
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 150, // Set max tokens as needed
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'].trim(); // Adjust based on API response structure
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load response');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load response');
    }
  }
}
