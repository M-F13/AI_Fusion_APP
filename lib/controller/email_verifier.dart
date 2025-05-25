import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailVerifier {
  static Future<bool> verifyEmailExists(String email) async {
    // First check basic format
    if (!_isValidEmailFormat(email)) return false;

    // Check domain exists (DNS MX lookup)
    final domain = email.split('@').last;
    if (!await _verifyDomainExists(domain)) return false;

    // For more thorough checking (optional paid service)
    // return await _checkWithEmailVerificationService(email);
    return true;
  }

  static bool _isValidEmailFormat(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static Future<bool> _verifyDomainExists(String domain) async {
    try {
      final response = await http.get(
        Uri.parse('https://dns.google/resolve?name=$domain&type=MX'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['Answer'] != null && data['Answer'].isNotEmpty;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

/*
  // For paid email verification services (like NeverBounce, Hunter.io)
  static Future<bool> _checkWithEmailVerificationService(String email) async {
    // Implementation depends on the service you choose
  }
  */
}