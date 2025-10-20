import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConfidencialAdminPage extends StatelessWidget {
  const ConfidencialAdminPage({super.key});

  // Simulación de datos de reportes enviados por los usuarios
  final List<Map<String, dynamic>> reportes = const [
    {
      "fecha": "2025-02-03",
      "area": "Recursos Humanos",
      "categoria": "Denuncia",
      "mensaje": "Se ha detectado un comportamiento inadecuado en la oficina."
    },
    {
      "fecha": "2025-02-02",
      "area": "Producción",
      "categoria": "Queja",
      "mensaje": "Las condiciones en el área de trabajo no son óptimas."
    },
    {
      "fecha": "2025-02-01",
      "area": "TI",
      "categoria": "Sugerencia",
      "mensaje": "Sería bueno implementar más capacitaciones técnicas."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Acércate',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ).animate().fadeIn(duration: 600.ms).slideY(
            begin: -0.5,
            end: 0,
            duration: 600.ms,
            curve: Curves.easeOut), // Animación añadida
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: reportes.length,
          itemBuilder: (context, index) {
            final reporte = reportes[index];

            return _buildReporteCard(
              fecha: reporte['fecha'],
              area: reporte['area'],
              categoria: reporte['categoria'],
              mensaje: reporte['mensaje'],
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.5, end: 0, duration: 500.ms);
          },
        ),
      ),
    );
  }

  Widget _buildReporteCard({
    required String fecha,
    required String area,
    required String categoria,
    required String mensaje,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.calendar_today, 'Fecha:', fecha),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.business, 'Área:', area),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.category, 'Categoría:', categoria),
            const Divider(height: 20, thickness: 1.2),
            Text(
              mensaje,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.red, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
