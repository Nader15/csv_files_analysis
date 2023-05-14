import 'dart:io';
import 'Logic/product analyzer.dart';


void main() {
  stdout.write('Enter the CSV file path (ex: C:\\Users\\User\\Desktop\\filename.csv): ');
  final inputFileName = stdin.readLineSync();

  final analyzer = ProductAnalyzer(inputFileName!);
  analyzer.analyzeProducts();
}
