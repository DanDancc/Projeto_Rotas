import '../models/local.dart';

class LocalRepository {
  // Singleton instance
  static final LocalRepository _instance = LocalRepository._internal();
  factory LocalRepository() => _instance;
  LocalRepository._internal() {
    print('✅ Repository inicializado');
  }

  List<Local> _locais = [];
  int _nextId = 1;

  bool testDatabase() {
    return true;
  }

  int insertLocal(Local local) {
    final newLocal = Local(
      id: _nextId,
      nome: local.nome,
      endereco: local.endereco,
      latitude: local.latitude,
      longitude: local.longitude,
      descricao: local.descricao,
      favorito: local.favorito,
      dataCriacao: DateTime.now(),
    );
    
    _locais.add(newLocal);
    _nextId++;
    
    print('✅ Local salvo: ${newLocal.nome} (ID: ${newLocal.id})');
    print('📊 Total de locais na memória: ${_locais.length}');
    
    return newLocal.id!;
  }

  List<Local> getAllLocais() {
    print('📋 Solicitando lista de locais. Total: ${_locais.length}');
    
    // Debug: mostra cada local
    for (var i = 0; i < _locais.length; i++) {
      print('   ${i + 1}. ${_locais[i].nome} (ID: ${_locais[i].id})');
    }
    
    return List.from(_locais); // Retorna cópia para não modificar a original
  }

  Local? getLocalById(int id) {
    try {
      return _locais.firstWhere((local) => local.id == id);
    } catch (e) {
      return null;
    }
  }

  int updateLocal(Local local) {
    final index = _locais.indexWhere((l) => l.id == local.id);
    if (index != -1) {
      _locais[index] = local;
      print('✅ Local atualizado: ${local.nome}');
      return 1;
    }
    return 0;
  }

  int deleteLocal(int id) {
    final initialLength = _locais.length;
    _locais.removeWhere((local) => local.id == id);
    final removedCount = initialLength - _locais.length;
    print('🗑️ $removedCount local(ais) excluído(s)');
    return removedCount;
  }

  List<Local> getFavoritos() {
    return _locais.where((local) => local.favorito).toList();
  }

  // Método para debug
  void debugInfo() {
    print('=== DEBUG REPOSITORY ===');
    print('Próximo ID: $_nextId');
    print('Total de locais: ${_locais.length}');
    for (var local in _locais) {
      print(' - ${local.nome} (ID: ${local.id})');
    }
    print('========================');
  }
}