import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Data/user_model.dart';
import '../Util/dbHelp.dart';

class fetchData{
  final String _url = 'https://api.github.com/repositories';

  Future<void> fetchAndSave() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      final dbHelper = DatabaseHelper();
      for (var item in jsonList) {
        final user = User.fromJson(item as Map<String, dynamic>);
        await dbHelper.insertUser(user);
      }
    } else {
      throw Exception('Failed to load repos: HTTP ${response.statusCode}');
    }
  }
}