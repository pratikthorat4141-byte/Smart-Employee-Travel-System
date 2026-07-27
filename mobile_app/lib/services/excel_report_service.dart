import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExcelReportService {
  ExcelReportService._();

  static Future<File> generateReport({
    required String title,
    required List<Map<String, dynamic>> data,
  }) async {
    final excel = Excel.createExcel();

    final sheet = excel['Report'];

    //----------------------------------------------------------
    // TITLE
    //----------------------------------------------------------

    sheet
        .cell(
          CellIndex.indexByColumnRow(
            columnIndex: 0,
            rowIndex: 0,
          ),
        )
        .value = TextCellValue(
      "SMART EMPLOYEE TRAVEL SYSTEM",
    );

    sheet
        .cell(
          CellIndex.indexByColumnRow(
            columnIndex: 0,
            rowIndex: 1,
          ),
        )
        .value = TextCellValue(title);

    sheet
        .cell(
          CellIndex.indexByColumnRow(
            columnIndex: 0,
            rowIndex: 2,
          ),
        )
        .value = TextCellValue(
      "Generated : ${DateFormat("dd MMM yyyy  hh:mm a").format(DateTime.now())}",
    );

    //----------------------------------------------------------
    // HEADER
    //----------------------------------------------------------

    if (data.isNotEmpty) {
      final headers = data.first.keys.toList();

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(
              CellIndex.indexByColumnRow(
                columnIndex: i,
                rowIndex: 4,
              ),
            )
            .value = TextCellValue(headers[i]);
      }

      //----------------------------------------------------------
      // DATA
      //----------------------------------------------------------

      for (int row = 0; row < data.length; row++) {
        final values =
            data[row].values.toList();

        for (int col = 0;
            col < values.length;
            col++) {
          sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: col,
                  rowIndex: row + 5,
                ),
              )
              .value = TextCellValue(
            values[col].toString(),
          );
        }
      }

      //----------------------------------------------------------
      // SUMMARY
      //----------------------------------------------------------

      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: 0,
              rowIndex: data.length + 7,
            ),
          )
          .value = TextCellValue(
        "Total Records : ${data.length}",
      );

      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: 0,
              rowIndex: data.length + 8,
            ),
          )
          .value = TextCellValue(
        "Smart Employee Travel Solution",
      );

      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: 0,
              rowIndex: data.length + 9,
            ),
          )
          .value = TextCellValue(
        "Smart Employee Travel Solution",
      );
    }

    //----------------------------------------------------------
    // SAVE FILE
    //----------------------------------------------------------

    final directory =
        await getApplicationDocumentsDirectory();

    final bytes = excel.save();

    if (bytes == null) {
      throw Exception(
        "Failed to generate Excel.",
      );
    }

    final file = File(
      "${directory.path}/${title.replaceAll(" ", "_")}.xlsx",
    );

    await file.writeAsBytes(bytes);

    return file;
  }
}