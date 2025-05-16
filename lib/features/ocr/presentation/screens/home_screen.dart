import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_providers.dart';
import '../providers/ocr_providers.dart';
import 'camera_screen.dart';
import 'documents_list_screen.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const DocumentsListScreen(),
    const SizedBox(), // Placeholder para la pantalla de cámara
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App OCR'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _selectedIndex != 1 
          ? _screens[_selectedIndex] 
          : const SizedBox(), // No mostramos un cuerpo para la cámara
      floatingActionButton: _selectedIndex == 1
          ? null
          : FloatingActionButton(
              onPressed: () => _navigateToCameraScreen(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.camera_alt),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            _navigateToCameraScreen(context);
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Documentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
        ],
      ),
    );
  }

  void _navigateToCameraScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
    
    if (result == true) {
      ref.read(documentsNotifierProvider.notifier).refreshDocuments();
    }
  }
}