import 'dart:convert';
import 'package:http/http.dart' as http;

class PSEAPI {
  static const String _baseUrl = 'https://api.pse.com.co/rest/api/v1';

  static Future<Map<String, dynamic>> getBankList() async {
    final response = await http.get(Uri.parse('$_baseUrl/banks'));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getBank(String bankId) async {
    final response = await http.get(Uri.parse('$_baseUrl/banks/$bankId'));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getAccountTypes() async {
    final response = await http.get(Uri.parse('$_baseUrl/accounttypes'));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> createTransaction(
      Map<String, dynamic> transaction) async {
    final response = await http.post(Uri.parse('$_baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction));
    return json.decode(response.body);
  }
}

Future<void> getBankList() async {
  final bankList = await PSEAPI.getBankList();
  print(bankList);
}

Future<void> getBank(String bankId) async {
  final bank = await PSEAPI.getBank(bankId);
  print(bank);
}

Future<void> getAccountTypes() async {
  final accountTypes = await PSEAPI.getAccountTypes();
  print(accountTypes);
}

Future<void> createTransaction() async {
  final transaction = {
    'bankCode': '1022',
    'bankInterface': '0',
    'returnURL': 'https://www.example.com/response',
    'reference': 'Test_001',
    'description': 'Test Payment',
    'language': 'ES',
    'currency': 'COP',
    'totalAmount': '10000',
    'taxAmount': '0',
    'devolutionBase': '0',
    'tipAmount': '0',
    'payer': {
      'documentType': 'CC',
      'document': '123456789',
      'firstName': 'John',
      'lastName': 'Doe',
      'company': 'Example Inc.',
      'emailAddress': 'johndoe@example.com',
      'address': '123 Main St.',
      'city': 'Bogotá',
      'province': 'Cundinamarca',
      'country': 'CO',
      'phone': '5555555',
      'mobile': '5555555'
    },
    'buyer': {
      'documentType': 'CC',
      'document': '123456789',
      'firstName': 'John',
      'lastName': 'Doe',
      'company': 'Example Inc.',
      'emailAddress': 'johndoe@example.com',
      'address': '123 Main St.',
      'city': 'Bogotá',
      'province': 'Cundinamarca',
      'country': 'CO',
      'phone': '5555555',
      'mobile': '5555555'
    },
    'shipping': {
      'documentType': 'CC',
      'document': '123456789',
      'firstName': 'John',
      'lastName': 'Doe',
      'company': 'Example Inc.',
      'emailAddress': 'johndoe@example.com',
      'address': '123 Main St.',
      'city': 'Bogotá',
      'province': 'Cundinamarca',
      'country': 'CO',
      'phone': '5555555',
      'mobile': '5555555'
    },
    'ipAddress': '127.0.0.1',
    'userAgent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
  };
  final transactionResult = await PSEAPI.createTransaction(transaction);
  print(transactionResult);
}