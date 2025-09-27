import 'package:flutter/material.dart';
import '../../models/local.dart';
import '../../services/local_serviceS.dart';
import 'local_form.dart';

class LocaisListPage extends StatefulWidget {
  const LocaisListPage({super.key});

  @override
  State<LocaisListPage> createState() => _LocaisListPageState();
}

class _LocaisListPageState extends State<LocaisListPage> {
  final LocalService _localService = LocalService();
  List<Local> _locais = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    print('🚀 LocaisListPage iniciada');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarLocais();
    });
  }

  void _carregarLocais() {
    print('🔄 Iniciando carregamento...');
    setState(() => _carregando = true);
    
    try {
      final novosLocais = _localService.listarLocais();
      print('✅ Dados recebidos: ${novosLocais.length} locais');
      
      setState(() {
        _locais = novosLocais;
        _carregando = false;
      });
      
      print('🎉 Interface atualizada com ${_locais.length} locais');
    } catch (e) {
      print('❌ Erro no carregamento: $e');
      setState(() => _carregando = false);
    }
  }

  void _editarLocal(Local local) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocalFormPage(local: local)),
    );
    
    if (resultado == true) {
      _carregarLocais();
    }
  }

  void _excluirLocal(Local local) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir "${local.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _localService.excluirLocal(local.id!);
              _carregarLocais();
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleFavorito(Local local) {
    _localService.toggleFavorito(local);
    _carregarLocais();
  }

  void _adicionarLocal() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocalFormPage()),
    );
    
    if (resultado == true) {
      _carregarLocais();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ Build da interface com ${_locais.length} locais');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.R.I - Meus Locais'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLocal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_locais.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text(
              'Nenhum local cadastrado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _adicionarLocal,
              child: const Text('Adicionar Primeiro Local'),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ${_locais.length} local(ais)'),
              Text('Favoritos: ${_locais.where((l) => l.favorito).length}'),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _locais.length,
            itemBuilder: (context, index) {
              final local = _locais[index];
              return _buildLocalItem(local);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocalItem(Local local) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            local.favorito ? Icons.favorite : Icons.favorite_border,
            color: local.favorito ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleFavorito(local),
        ),
        title: Text(
          local.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(local.endereco),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editarLocal(local),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _excluirLocal(local),
              ),
            ],
          ),
        ),
      ),
    );
  }
}