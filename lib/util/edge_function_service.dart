import 'package:supabase_flutter/supabase_flutter.dart';

class EdgeFunctionService {
  final _supabase = Supabase.instance.client;

  Future<void> callMyFunction() async {
    try {
      final response = await _supabase.functions.invoke(
        'my-function',
        body: {'name': 'Flutter'},
      );

      if (response.status != 200) {
        throw Exception('Error: ${response.data}');
      }

      print('Function response: ${response.data}');
    } catch (e) {
      print('Error calling function: $e');
    }
  }
}