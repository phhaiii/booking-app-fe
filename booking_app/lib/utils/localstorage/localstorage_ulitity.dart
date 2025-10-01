import 'package:get_storage/get_storage.dart';

class WLocalStorage{
  static final WLocalStorage _instance = WLocalStorage._internal();
  
  factory WLocalStorage() {
    return _instance;
  }
  WLocalStorage._internal();

  final _storage = GetStorage();

  Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }
  T? readData<T>(String key){
    return _storage.read<T>(key);
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }
  Future<void> clearAll() async {
    await _storage.erase();
  }

}