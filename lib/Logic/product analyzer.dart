import 'dart:io';
import 'package:csv/csv.dart';
import '../Models/product_model.dart';


class ProductAnalyzer {
  final String inputFileName;

  ProductAnalyzer(this.inputFileName);

  void analyzeProducts() {
    final inputCsvFile = File(inputFileName);
    final csvString = inputCsvFile.readAsStringSync();
    final products = parseCsvData(csvString);
    final totalRecords = products.length;
    final groupedProducts = groupProductsByName(products);

    final averageQuantityData = <List<dynamic>>[];
    final popularBrandData = <List<dynamic>>[];

    for (final entry in groupedProducts.entries) {
      final productName = entry.key;
      final productsByName = entry.value;

      final averageQuantity =
          calculateAverageQuantity(productsByName, totalRecords);
      averageQuantityData.add([productName, averageQuantity]);

      final popularBrand = findMostPopularBrand(productsByName);
      popularBrandData.add([productName, popularBrand]);
    }

    final averageQuantityCsv =
        ListToCsvConverter().convert(averageQuantityData);
    final popularBrandCsv = ListToCsvConverter().convert(popularBrandData);

    final averageQuantityFile =
        File('0_${inputFileName.split(Platform.pathSeparator).last}');
    averageQuantityFile.writeAsStringSync(averageQuantityCsv);
    print(
        'Output 0_CSV file created successfully at: ${averageQuantityFile.absolute.path}');

    final popularBrandFile =
        File('1_${inputFileName.split(Platform.pathSeparator).last}');
    popularBrandFile.writeAsStringSync(popularBrandCsv);
    print(
        'Output 1_CSV file created successfully at: ${popularBrandFile.absolute.path}');
  }
}

List<Product> parseCsvData(String csvString) {
  final csvData = CsvToListConverter().convert(csvString);

  final products = <Product>[];
  for (final row in csvData) {
    final productName = row[2].toString();
    final productBrand = row[4].toString();
    final productQuantity = int.parse(row[3].toString());

    final product = Product(productName, productBrand, productQuantity);
    products.add(product);
  }

  return products;
}

Map<String, List<Product>> groupProductsByName(List<Product> products) {
  final groupedProducts = <String, List<Product>>{};
  for (final product in products) {
    if (!groupedProducts.containsKey(product.name)) {
      groupedProducts[product.name] = [];
    }

    groupedProducts[product.name]!.add(product);
  }

  return groupedProducts;
}

double calculateAverageQuantity(List<Product> products, int totalRecords) {
  final totalQuantity =
  products.fold(0, (sum, product) => sum + product.quantity);
  return totalQuantity / totalRecords;
}

String findMostPopularBrand(List<Product> products) {
  final brandCounts = <String, int>{};
  for (final product in products) {
    final brand = product.brand;
    brandCounts[brand] = (brandCounts[brand] ?? 0) + 1;
  }

  return brandCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}
