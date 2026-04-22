import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:image_picker/image_picker.dart';          // Mobile
import 'package:image_picker_web/image_picker_web.dart';  // Web

import '../models/expense_model.dart';
import '../services/expense_service.dart';
import '../services/expense_media_service.dart';
import '../core/api_client.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final String token;
  final ExpenseModel expense;
  final bool isPremium;

  const ExpenseDetailScreen({
    super.key,
    required this.token,
    required this.expense,
    required this.isPremium,
  });

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final ExpenseService _expenseService = ExpenseService();
  final ExpenseMediaService _mediaService = ExpenseMediaService();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;

  late DateTime _selectedDate;

  bool _editing = false;
  bool _loading = false;

  // 📸 Mídias
  List<Map<String, dynamic>> _media = [];
  bool _loadingMedia = false;

  @override
  void initState() {
    super.initState();

    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _categoryController =
        TextEditingController(text: widget.expense.category);

    _selectedDate = widget.expense.date;

    if (widget.isPremium) {
      _loadMedia();
    }
  }

  // =====================
  // 📂 LISTAR MÍDIAS
  // =====================
  Future<void> _loadMedia() async {
    setState(() => _loadingMedia = true);

    try {
      final data = await _mediaService.getMedia(
        token: widget.token,
        expenseId: widget.expense.id,
      );

      if (!mounted) return;

      setState(() {
        _media = data;
        _loadingMedia = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingMedia = false);
    }
  }

  // =====================
  // 🖼️ GALERIA (WEB + MOBILE)
  // =====================
  Future<void> _pickImagesFromGallery() async {
    List<Uint8List> images = [];

    if (kIsWeb) {
      final webImages = await ImagePickerWeb.getMultiImagesAsBytes();
      if (webImages != null) images = webImages;
    } else {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      for (final file in files) {
        images.add(await file.readAsBytes());
      }
    }

    if (images.isEmpty) return;

    try {
      await _mediaService.uploadImages(
        token: widget.token,
        expenseId: widget.expense.id,
        images: images,
      );

      _loadMedia();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao anexar imagens')),
      );
    }
  }

  // =====================
  // 📷 CÂMERA (MOBILE ONLY)
  // =====================
  Future<void> _takePhotoWithCamera() async {
    if (kIsWeb) return;

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return;

      final bytes = await photo.readAsBytes();

      await _mediaService.uploadSingleImage(
        token: widget.token,
        expenseId: widget.expense.id,
        image: bytes,
      );

      _loadMedia();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao usar a câmera')),
      );
    }
  }

  // =====================
  // 🗑️ REMOVER MÍDIA
  // =====================
  Future<void> _deleteMedia(String mediaId) async {
    await _mediaService.deleteMedia(
      token: widget.token,
      mediaId: mediaId,
    );
    _loadMedia();
  }

  // =====================
  // ✏️ SALVAR DESPESA
  // =====================
  Future<void> _save() async {
    setState(() => _loading = true);

    try {
      await _expenseService.updateExpense(
        widget.token,
        widget.expense.id,
        _descriptionController.text.trim(),
        double.parse(_amountController.text),
        _categoryController.text.trim(),
        _selectedDate,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  // =====================
  // ❌ EXCLUIR DESPESA
  // =====================
  Future<void> _deleteExpense() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir despesa'),
        content: const Text('Deseja realmente excluir esta despesa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _expenseService.deleteExpense(
      widget.token,
      widget.expense.id,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.save : Icons.edit),
            onPressed: _loading
                ? null
                : () {
                    if (_editing) {
                      _save();
                    } else {
                      setState(() => _editing = true);
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _loading ? null : _deleteExpense,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              enabled: _editing,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _amountController,
              enabled: _editing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _categoryController,
              enabled: _editing,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text('Data: ${_formatDate(_selectedDate)}'),
                const Spacer(),
                if (_editing)
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Alterar'),
                  ),
              ],
            ),

            // =====================
            // ⭐ MÍDIAS (PREMIUM)
            // =====================
            if (widget.isPremium) ...[
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImagesFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeria'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!kIsWeb)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _takePhotoWithCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Câmera'),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              if (_loadingMedia)
                const Center(child: CircularProgressIndicator())
              else if (_media.isEmpty)
                const Text('Nenhuma imagem adicionada')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _media.map((m) {
                    return Stack(
                      children: [
                        Image.network(
                          '${ApiClient.baseUrl}${m['url']}',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _deleteMedia(m['_id']),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }
}