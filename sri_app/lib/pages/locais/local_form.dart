import 'package:flutter/material.dart';
import '../../models/local.dart';
import '../../services/local_services.dart';

class LocalFormPage extends StatefulWidget {
  final Local? local;

  const LocalFormPage({super.key, this.local});

  @override
  State<LocalFormPage> createState() => _LocalFormPageState();
}

class _LocalFormPageState extends State<LocalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _localService = LocalService();

  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _favorito = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.local != null) {
      _carregarDadosLocal();
    } else {
      _latitudeController.text = '-23.5505';
      _longitudeController.text = '-46.6333';
    }
  }

  void _carregarDadosLocal() {
    final local = widget.local!;
    _nomeController.text = local.nome;
    _enderecoController.text = local.endereco;
    _descricaoController.text = local.descricao ?? '';
    _latitudeController.text = local.latitude.toString();
    _longitudeController.text = local.longitude.toString();
    _favorito = local.favorito;
  }

  void _salvarLocal() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final local = Local(
        id: widget.local?.id,
        nome: _nomeController.text.trim(),
        endereco: _enderecoController.text.trim(),
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        descricao: _descricaoController.text.trim().isEmpty 
            ? null 
            : _descricaoController.text.trim(),
        favorito: _favorito,
      );

      if (widget.local == null) {
        _localService.criarLocal(local);
      } else {
        _localService.atualizarLocal(local);
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.local == null ? 'Novo Local' : 'Editar Local'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Local*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o endereço';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a latitude';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Latitude inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a longitude';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Longitude inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Favorito'),
                value: _favorito,
                onChanged: (value) => setState(() => _favorito = value),
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _salvando ? null : _salvarLocal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _salvando
                    ? const CircularProgressIndicator()
                    : Text(widget.local == null ? 'Salvar Local' : 'Atualizar Local'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}