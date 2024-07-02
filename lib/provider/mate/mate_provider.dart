import 'package:mobile/model/schedule_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MateProvider {
  static final supabase = Supabase.instance.client;

  /* Get */
  Future<List<Map<String, dynamic>>> getAllMates() async {
    final response = await supabase.from('mate').select();
    return response;
  }

  /* Update */

  /* Delete */
}
