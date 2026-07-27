import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  EmailService._();

  //==========================================================
  // Brevo SMTP
  //==========================================================

  static const String _smtpHost = "smtp-relay.brevo.com";

  static const int _smtpPort = 587;

  static const String _username = "YOUR_BREVO_LOGIN";

  static const String _password = "YOUR_BREVO_SMTP_KEY";

  static const String _senderEmail =
      "YOUR_VERIFIED_EMAIL@gmail.com";

  static const String _senderName =
      "Smart Employee Travel Solution";

  //==========================================================
  // SEND OTP
  //==========================================================

  static Future<bool> sendOtpEmail({
    required String name,
    required String email,
    required String otp,
  }) async {
    try {
      final smtpServer = SmtpServer(
        _smtpHost,
        port: _smtpPort,
        username: _username,
        password: _password,
      );

      final message = Message()
        ..from = Address(
          _senderEmail,
          _senderName,
        )
        ..recipients.add(email)
        ..subject =
            "Password Reset OTP"
        ..text = '''
Hello $name,

We received a request to reset your password for your Smart Employee Travel Solution account.

Your One-Time Password (OTP) is:

━━━━━━━━━━━━
$otp
━━━━━━━━━━━━

This OTP is valid for 5 minutes.

If you did not request a password reset, please ignore this email. Your account will remain secure.

Thank you,

Smart Employee Travel Solution Team
''';

      await send(
        message,
        smtpServer,
      );

      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }
}