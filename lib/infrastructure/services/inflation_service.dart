import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

abstract class IInflationService {
  Future<double?> getLatestMonthlyInflation();
}

@Injectable(as: IInflationService)
class InflationService implements IInflationService {
  // Código 433 = IPCA mensal
  static const String _baseUrl = 'https://api.bcb.gov.br/dados/serie/bcdata.sgs.433/dados/ultimos/1?formato=json';

  @override
  Future<double?> getLatestMonthlyInflation() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final item = data.first;
          // Expected format: {"data": "01/MM/YYYY", "valor": "0.56"}
          
          final String valorStr = item['valor'] as String;
          // Replace comma with dot if necessary
          final double valor = double.parse(valorStr.replaceAll(',', '.'));
          
          // API returns percentage (e.g., 0.56 for 0.56%). Convert to decimal (0.0056)
          return valor / 100.0;
        }
      }
      return null;
    } catch (e) {
      // Log error
      print('Erro ao buscar inflação: $e');
      return null;
    }
  }
}
