import 'package:flutter/material.dart';

class VerConfidencialidadPage extends StatelessWidget {
  final List<Map<String, dynamic>> mensajes = [
    {
      'id': 1,
      'fecha': '2023-10-01',
      'area': 'TI',
      'categoria': 'Sugerencia',
      'mensaje': 'Necesitamos más recursos para el proyecto X.',
    },
    // Más mensajes...
  ];

  VerConfidencialidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Confidencialidad'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mensajes.length,
        itemBuilder: (context, index) {
          final mensaje = mensajes[index];
          return _buildMensajeCard(mensaje);
        },
      ),
    );
  }

  Widget _buildMensajeCard(Map<String, dynamic> mensaje) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${mensaje['fecha']}'),
            Text('Área: ${mensaje['area']}'),
            Text('Categoría: ${mensaje['categoria']}'),
            Text('Mensaje: ${mensaje['mensaje']}'),
          ],
        ),
      ),
    );
  }
}
