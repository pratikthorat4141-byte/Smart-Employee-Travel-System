import 'dart:io';

import 'package:share_plus/share_plus.dart';

class PaymentShareService {
  PaymentShareService._();

  static final PaymentShareService instance =
      PaymentShareService._();

  //--------------------------------------------------
  // SHARE FILE
  //--------------------------------------------------

  Future<void> shareFile(
    File file, {
    String? text,
    String? subject,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
        text: text,
        subject: subject,
      ),
    );
  }
}