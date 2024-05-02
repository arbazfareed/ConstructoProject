import 'package:http/http.dart' as http;

class ValidationUtils {
  static Future<bool> isEmailValid(String email) async {
    // Make API call to validate email
    // Replace API_ENDPOINT with the actual endpoint for email validation
    final response = await http.post(
      Uri.parse('API_ENDPOINT'),
      body: {'email': email},
    );

    // Check if the response is successful and email is valid
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> validatePhoneNumber(String phoneNumber) async {
    // Make API call to validate phone number
    // Replace API_ENDPOINT with the actual endpoint for phone number validation
    final response = await http.post(
      Uri.parse('API_ENDPOINT'),
      body: {'phone': phoneNumber},
    );

    // Check if the response is successful and phone number is valid
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
