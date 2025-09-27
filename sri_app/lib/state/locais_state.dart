import 'package:flutter/foundation.dart';
import '../models/local.dart';

class LocaisState with ChangeNotifier {
  List<Local> _locais = [];
  bool _carregando = false;

  List<Local> get locais => List.from(_locais);
  bool get carregando => _carregando;

  void setCarregando(bool value) {
    _carregando = value;
    notifyListeners();
  }

  void setLocais(List<Local> novosLocais) {
    _locais = List.from(novosLocais);
    notifyListeners();
  }

  void adicionarLocal(Local local) {
    _locais.add(local);
    notifyListeners();
  }

  void atualizarLocal(Local local) {
    final index = _locais.indexWhere((l) => l.id == local.id);
    if (index != -1) {
      _locais[index] = local;
      notifyListeners();
    }
  }

  void removerLocal(int id) {
    _locais.removeWhere((local) => local.id == id);
    notifyListeners();
  }
}