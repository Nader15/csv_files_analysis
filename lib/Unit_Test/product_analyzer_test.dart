import 'package:test/test.dart';
import 'dart:io';
import '../Logic/product analyzer.dart';

void main() {
  group('ProductAnalyzer', () {
    late ProductAnalyzer productAnalyzer;
    const sampleCsvPath = 'ex: C:\\Users\\user_name\\Desktop\\products.csv';
    const outputDirectory = 'ex: C:\\Users\\user_name\\StudioProjects\\csv_files_analysis';

    setUp(() {
      productAnalyzer = ProductAnalyzer(sampleCsvPath);
    });

    test('analyzeProducts should create output CSV files', () {
      final outputFilePath1 = '$outputDirectory/0_products.csv';
      final outputFilePath2 = '$outputDirectory/1_products.csv';

      productAnalyzer.analyzeProducts();

      final file1 = File(outputFilePath1);
      final file2 = File(outputFilePath2);

      expect(file1.existsSync(), isTrue);
      expect(file2.existsSync(), isTrue);

      // Clean up
      file1.deleteSync();
      file2.deleteSync();
    });
  });
}
