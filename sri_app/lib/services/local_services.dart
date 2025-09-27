import '../models/local.dart';
import '../repositories/local_repository.dart';

class LocalService {
  // Singleton instance
  static final LocalService _instance = LocalService._internal();
  factory LocalService() => _instance;
  LocalService._internal() {
    print('✅ Service inicializado');
  }

  final LocalRepository _repository = LocalRepository();

  int criarLocal(Local local) {
    print('🎯 Service: Criando local ${local.nome}');
    return _repository.insertLocal(local);
  }

  List<Local> listarLocais() {
    print('🎯 Service: Listando locais');
    _repository.debugInfo(); // Debug
    return _repository.getAllLocais();
  }

  Local? buscarLocalPorId(int id) {
    return _repository.getLocalById(id);
  }

  int atualizarLocal(Local local) {
    return _repository.updateLocal(local);
  }

  int excluirLocal(int id) {
    return _repository.deleteLocal(id);
  }

  List<Local> listarFavoritos() {
    return _repository.getFavoritos();
  }

  void toggleFavorito(Local local) {
    local.favorito = !local.favorito;
    _repository.updateLocal(local);
  }
}