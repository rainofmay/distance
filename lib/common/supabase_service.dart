// singleton pattern class
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  //private 한 생성자 선언, 호출이 아닌 빈 생성자를 만드는 선언
  //Dart에선 생성자가 없을경우 자동으로 Public한 생성자를 만들어 버린다.
  //이를 막기위해 Private한 생성자를 만들어줘서 자동으로 만들어주는 생성자가 되지 않도록 방지.
  SupabaseService._internal();

  // 싱글톤 패턴을 활용하여 클래스의 인스턴스를 딱 하나만 생성할 수 있도록 허용
  // 생성자를 호출하고 반환된 Singleton 인스턴스를 _instance 변수에 할당
  static final SupabaseService _instance = SupabaseService._internal();

  // 생성되었던 인스턴스를 활용처에 반환해주는 factory 생성자. 매번 동일한 인스턴스를 반환
  factory SupabaseService() => _instance;

  // supabase 호출 로직 메서드 구현
}