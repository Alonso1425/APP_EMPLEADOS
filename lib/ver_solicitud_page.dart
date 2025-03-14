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

  // Datos de ejemplo para el Proceso de Autorización
  final List<Map<String, dynamic>> procesoAutorizacion = [
    {
      'id': 1,
      'fechaSolicitud': '01/10/2023',
      'autorizacion1': 'Pendiente',
      'motivoRechazo1': '',
      'autorizacion2': 'Aprobada',
      'motivoRechazo2': '',
    },
    {
      'id': 2,
      'fechaSolicitud': '10/10/2023',
      'autorizacion1': 'Rechazada',
      'motivoRechazo1': 'No hay suficiente personal disponible.',
      'autorizacion2': 'Pendiente',
      'motivoRechazo2': '',
    },
  ];

  // Datos de ejemplo para el Historial
  final List<Map<String, dynamic>> historial = [
    {
      'id': 1,
      'año': 2023,
      'fechaSolicitud': '01/10/2023',
      'diasSolicitados': 5,
      'fechasSolicitadas': '01/10/2023 - 05/10/2023',
      'diaAutorizacion': '03/10/2023',
      'rechazo': '',
    },
    {
      'id': 2,
      'año': 2023,
      'fechaSolicitud': '10/10/2023',
      'diasSolicitados': 3,
      'fechasSolicitadas': '10/10/2023 - 12/10/2023',
      'diaAutorizacion': '11/10/2023',
      'rechazo': 'No hay suficiente personal disponible.',
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
      backgroundColor: Colors.grey[100],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Proceso de Autorización
            Text(
              'Estatus / Historial de Solicitud de Vacaciones',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            if (procesoAutorizacion.isEmpty)
              Center(
                child: Text(
                  'No hay solicitudes de autorización por mostrar.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ...procesoAutorizacion.map((solicitud) {
                return SlideTransition(
                  position: _animation,
                  child: _buildProcesoAutorizacionCard(solicitud),
                );
              }).toList(),

            const SizedBox(height: 32.0),

            // Sección: Historial
            Text(
              'Historial',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16.0),
            ...historial.map((solicitud) {
              return SlideTransition(
                position: _animation,
                child: _buildHistorialCard(solicitud),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Tarjeta para el Proceso de Autorización
  Widget _buildProcesoAutorizacionCard(Map<String, dynamic> solicitud) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.confirmation_number, 'No. Solicitud',
                solicitud['id'].toString()),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.calendar_today, 'Fecha de Solicitud',
                solicitud['fechaSolicitud']),
            const SizedBox(height: 8.0),
            _buildAutorizacionRow('Autorización 1', solicitud['autorizacion1'],
                solicitud['motivoRechazo1']),
            const SizedBox(height: 8.0),
            _buildAutorizacionRow('Autorización 2', solicitud['autorizacion2'],
                solicitud['motivoRechazo2']),
          ],
        ),
      ),
    );
  }

  // Tarjeta para el Historial
  Widget _buildHistorialCard(Map<String, dynamic> solicitud) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.confirmation_number, 'No. Solicitud',
                solicitud['id'].toString()),
            const SizedBox(height: 8.0),
            _buildInfoRow(
                Icons.calendar_today, 'Año', solicitud['año'].toString()),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.date_range, 'Fecha de Solicitud',
                solicitud['fechaSolicitud']),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.timelapse, 'Días solicitados',
                solicitud['diasSolicitados'].toString()),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.calendar_view_day, 'Fechas solicitadas',
                solicitud['fechasSolicitadas']),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.event_available, 'Día de Autorización',
                solicitud['diaAutorizacion']),
            if (solicitud['rechazo'] != null && solicitud['rechazo'].isNotEmpty)
              _buildInfoRow(Icons.warning, 'Rechazo', solicitud['rechazo']),
          ],
        ),
      ),
    );
  }

  // Método para construir una fila de información
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

  // Método para construir una fila de autorización
  Widget _buildAutorizacionRow(
      String label, String status, String motivoRechazo) {
    Color statusColor;
    switch (status) {
      case 'Aprobada':
        statusColor = Colors.green;
        break;
      case 'Rechazada':
        statusColor = Colors.red;
        break;
      case 'Pendiente':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user, color: Colors.teal[800], size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(Icons.circle, color: statusColor, size: 16.0),
            const SizedBox(width: 4.0),
            Text(
              status,
              style: TextStyle(
                fontSize: 16.0,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (motivoRechazo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 28.0, top: 4.0),
            child: Text(
              'Motivo: $motivoRechazo',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
