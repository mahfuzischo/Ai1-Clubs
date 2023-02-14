import 'package:ai1_clubs/userData.dart';
import 'package:ai1_clubs/methods.dart';
import 'package:flutter/widgets.dart';

class provider with ChangeNotifier {
  User? _user;
  final methods _methods = methods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _methods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
