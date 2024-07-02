import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/provider/user/user_provider.dart';

class UserRepository {
  final UserProvider _userProvider;

  UserRepository({
    required UserProvider userProvider,
  }) : _userProvider = userProvider;

  /* Get Schedule List */
  Future<UserModel> fetchMyProfile() async {
    final json = await _userProvider.getMyProfileJson();
    return UserModel.fromJson(json as Map<String, dynamic>);
  }
}
