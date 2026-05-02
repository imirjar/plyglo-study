import 'package:flutter/foundation.dart';
import 'package:poliglotim/domain/models/user.dart';

import '../../../../utils/result.dart';

abstract class UserRepository extends ChangeNotifier {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  Future<bool> get isAuthenticated;

  /// Perform login
  Future<Result<void>> login();

  /// Perform logout
  Future<Result<void>> logout();

  Future<Result<User>> getUserData();
  // Future<Result<void>> uploadProfilePhoto(String imagePath);
  // Future<Result<void>> updateUserProfile({required String firstName, required String lastName});
}
