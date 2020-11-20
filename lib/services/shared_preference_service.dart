import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  Future<bool> alreadyViewOnboarding() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool alreadyView = pref.getBool('alreadyView') ?? false;

    return alreadyView;
  }

  Future<bool> isLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLogin = pref.getBool('isLogin') ?? false;

    return isLogin;
  }

  Future<void> clearLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('isLogin');
  }

  Future<String> saveDataPref({dataType, key, value}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    switch (dataType) {
      case 'bool':
        pref.setBool(key, value);
        break;
      case 'int':
        pref.setInt(key, value);
        break;
      case 'double':
        pref.setDouble(key, value);
        break;
      case 'string':
        pref.setString(key, value);
        break;
      default:
        return 'invalid datatype';
        break;
    }

    var result =
        "berhasil menyimpan tipe data $dataType, dengan key $key, dan value $value";
    return result;
  }
}
