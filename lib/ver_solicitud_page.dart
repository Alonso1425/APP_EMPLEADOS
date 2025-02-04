import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class VerSolicitudPage extends StatefulWidget {
  @override
  _VerSolicitudPageState createState() => _VerSolicitudPageState();
}

class _VerSolicitudPageState extends State<VerSolicitudPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> solicitudes = [
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-01',
      'rangoFechas': '01/10/2023 - 05/10/2023',
      'estado': 'Aprobada',
      'motivoRechazo': '',
    },
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-10',
      'rangoFechas': '10/10/2023 - 15/10/2023',
      'estado': 'Rechazada',
      'motivoRechazo': 'No hay suficiente personal disponible.',
    },
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-20',
      'rangoFechas': '20/10/2023 - 25/10/2023',
      'estado': 'Pendiente',
      'motivoRechazo': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Mis Solicitudes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: solicitudes.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _animation,
            child: _buildSolicitudCard(solicitudes[index]),
          );
        },
      ),
    );
  }

  Widget _buildSolicitudCard(Map<String, dynamic> solicitud) {
    Color estadoColor;
    switch (solicitud['estado']) {
      case 'Aprobada':
        estadoColor = Colors.green;
        break;
      case 'Rechazada':
        estadoColor = Colors.red;
        break;
      case 'Pendiente':
        estadoColor = Colors.orange;
        break;
      default:
        estadoColor = Colors.grey;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.person, 'Nombre', solicitud['nombre']),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.work, 'Cargo', solicitud['cargo']),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.business, 'Área', solicitud['area']),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.calendar_today, 'Fecha de Solicitud',
                solicitud['fechaSolicitud']),
            const SizedBox(height: 8.0),
            _buildInfoRow(
                Icons.date_range, 'Rango de Fechas', solicitud['rangoFechas']),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.circle, color: estadoColor, size: 16.0),
                const SizedBox(width: 8.0),
                Text(
                  'Estado: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                Text(
                  solicitud['estado'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: estadoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (solicitud['estado'] == 'Rechazada') ...[
              const SizedBox(height: 8.0),
              _buildInfoRow(Icons.warning, 'Motivo de Rechazo',
                  solicitud['motivoRechazo']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal[800], size: 20.0),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
