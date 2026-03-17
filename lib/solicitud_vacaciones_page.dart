import 'dart:convert';
import 'package:empleados_app/ver_solicitud_page.dart';
import 'package:http/http.dart' as http;
import 'package:empleados_app/solicitud_emergencia_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SolicitudVacacionesPage extends StatefulWidget {
  final String username;
  final String rol;
  final String roluser;
  final String userId;

  const SolicitudVacacionesPage({
    super.key,
    this.username = '',
    this.rol = '',
    this.roluser = '',
    this.userId = '',
  });

  @override
  _SolicitudVacacionesPageState createState() =>
      _SolicitudVacacionesPageState();
}

class _SolicitudVacacionesPageState extends State<SolicitudVacacionesPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController rolController = TextEditingController();
  final TextEditingController roluserController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController rangoFechaController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int _diasSeleccionados = 0;
  final List<DateTime> _diasSolicitados = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;

  // Paleta de colores profesional
  final Color _primaryColor = const Color(0xFF2C3E50);
  final Color _secondaryColor = const Color(0xFF3498DB);
  final Color _accentColor = const Color(0xFFE74C3C);
  final Color _successColor = const Color(0xFF27AE60);
  final Color _warningColor = const Color(0xFFF39C12);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2C3E50);
  final Color _hintColor = const Color(0xFF7F8C8D);

  @override
  void initState() {
    super.initState();
    _setDate();
    _loadUserData();
    _focusedDay = DateTime.now();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showInformativeDialog());
  }

  void _loadUserData() {
    setState(() {
      usernameController.text = widget.username;
      rolController.text = widget.roluser;
      roluserController.text = widget.rol;
    });
  }

  void _setDate() {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    dateController.text = currentDate;
  }

  // Función para manejar la selección de fechas
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    DateTime minDate = calcularFechaMinima();

    if (selectedDay.isBefore(minDate)) {
      _mostrarMensajeAdvertencia(
        'Por favor selecciona una fecha con al menos 7 días hábiles de anticipación.',
      );
      return;
    }

    setState(() {
      _focusedDay = focusedDay;

      // Agregar o eliminar el día seleccionado de la lista de días solicitados
      if (_diasSolicitados.contains(selectedDay)) {
        _diasSolicitados.remove(selectedDay);
      } else {
        _diasSolicitados.add(selectedDay);
      }

      // Actualizar el contador de días seleccionados
      _diasSeleccionados = _diasSolicitados.length;

      // Actualizar el campo de "Rango de Fechas Seleccionado" con los días seleccionados
      if (_diasSolicitados.isNotEmpty) {
        _diasSolicitados.sort((a, b) => a.compareTo(b));
        rangoFechaController.text = _diasSolicitados
            .map((e) => DateFormat('dd/MM/yyyy').format(e))
            .join(' - ');
      } else {
        rangoFechaController.clear();
      }
    });
  }

  // Calcular la fecha mínima permitida (7 días hábiles a partir de la fecha)
  DateTime calcularFechaMinima() {
    DateTime minDate = DateTime.now();
    int daysToAdd = 7;
    while (daysToAdd > 0) {
      minDate = minDate.add(Duration(days: 1));
      if (minDate.weekday != DateTime.saturday &&
          minDate.weekday != DateTime.sunday) {
        daysToAdd--;
      }
    }
    return minDate;
  }

  // Función para enviar la solicitud
  Future<void> _enviarSolicitud() async {
    if (_diasSeleccionados == 0) {
      _mostrarMensajeError(
          'Por favor selecciona al menos un día de vacaciones.');
      return;
    }

    final url = Uri.parse(
        'http://192.168.1.99/api/vacaciones/enviar_solicitud_vacaciones.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
          'username': widget.username,
          'rol_user': widget.roluser,
          'rol': widget.rol,
          'fecha_solicitud': dateController.text,
          'rango_fechas': rangoFechaController.text,
          'dias_seleccionados': _diasSeleccionados,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('error')) {
          _mostrarMensajeError(responseData['error']);
        } else {
          _mostrarMensajeExito(
              responseData['message'] ?? 'Solicitud enviada con éxito');
          _resetFields();
        }
      } else {
        _mostrarMensajeError(
            'Error al enviar la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      _mostrarMensajeError('Error de conexión: $e');
    }
  }

  // Mensajes de notificación
  void _mostrarMensajeExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _accentColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _mostrarMensajeAdvertencia(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _warningColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  // Función para limpiar los campos
  void _resetFields() {
    setState(() {
      _diasSolicitados.clear();
      _diasSeleccionados = 0;
      rangoFechaController.clear();
      _focusedDay = DateTime.now();
    });
  }

  // Widget para mostrar alerta de información
  void _showInformativeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: _accentColor),
              SizedBox(width: 10),
              Text(
                'Información Importante',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            'La solicitud de vacaciones se debe realizar con 7 días hábiles de anticipación. Los fines de semana no se consideran días hábiles.',
            style: TextStyle(
              color: _textColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ENTENDIDO',
                style: TextStyle(
                  color: _secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: _backgroundColor,
      // appBar: AppBar(
      //   title: Text(
      //     'Solicitud de Vacaciones',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.w600,
      //       fontSize: isSmallScreen ? 18 : 20,
      //     ),
      //   ).animate().fadeIn(duration: 500.ms),
      //   backgroundColor: _primaryColor,
      //   centerTitle: true,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo
              _buildHeaderSection(isSmallScreen),
              SizedBox(height: 20),

              // Información del empleado
              _buildEmployeeInfoSection(isSmallScreen),
              SizedBox(height: 20),

              // Calendario
              _buildCalendarSection(isSmallScreen),
              SizedBox(height: 20),

              // Resumen de selección
              _buildSelectionSummarySection(isSmallScreen),
              SizedBox(height: 25),

              // Botones de acción
              _buildActionButtonsSection(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.beach_access,
            size: 40,
            color: _secondaryColor,
          ),
          SizedBox(height: 10),
          Text(
            'Solicitud de Vacaciones',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Selecciona los días que deseas tomar de vacaciones',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: _hintColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildEmployeeInfoSection(bool isSmallScreen) {
    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Información del Empleado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              label: 'Fecha de Solicitud',
              value: dateController.text,
              icon: Icons.today,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              label: 'Nombre del Empleado',
              value: usernameController.text,
              icon: Icons.person,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              label: 'Cargo',
              value: rolController.text,
              icon: Icons.business_center,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              label: 'Área/Departamento',
              value: roluserController.text,
              icon: Icons.apartment,
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideX(
          begin: -0.5,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 600.ms);
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _hintColor),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: _hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(bool isSmallScreen) {
    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Selecciona tus días de vacaciones',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => _diasSolicitados.contains(day),
                onDaySelected: _onDaySelected,
                calendarFormat: _calendarFormat,
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: _secondaryColor),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: _secondaryColor),
                  headerPadding: EdgeInsets.symmetric(vertical: 12),
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _accentColor,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: _secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: _secondaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: _secondaryColor),
                  ),
                  todayTextStyle: TextStyle(
                    color: _secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  defaultTextStyle: TextStyle(
                    color: _textColor,
                  ),
                  weekendTextStyle: TextStyle(
                    color: _accentColor,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                availableGestures: AvailableGestures.all,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '💡 Toca los días que deseas tomar de vacaciones',
              style: TextStyle(
                fontSize: 12,
                color: _hintColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideX(
          begin: 0.5,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 600.ms);
  }

  Widget _buildSelectionSummarySection(bool isSmallScreen) {
    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Resumen de Selección',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSummaryItem(
              icon: Icons.calendar_today,
              label: 'Días Seleccionados',
              value: '$_diasSeleccionados',
              color: _secondaryColor,
            ),
            SizedBox(height: 12),
            _buildSummaryItem(
              icon: Icons.date_range,
              label: 'Fechas Seleccionadas',
              value: rangoFechaController.text.isNotEmpty
                  ? rangoFechaController.text
                  : 'No hay fechas seleccionadas',
              color: _diasSeleccionados > 0 ? _successColor : _hintColor,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms);
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: _hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(bool isSmallScreen) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _enviarSolicitud,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _diasSeleccionados > 0 ? _successColor : Colors.grey[400],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: isSmallScreen ? 16 : 18,
              ),
              textStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, size: 20, color: Colors.white),
                SizedBox(width: 10),
                Text('ENVIAR SOLICITUD DE VACACIONES'),
              ],
            ),
          ),
        ).animate().scale(delay: 800.ms),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SolicitudEmergenciaPage(
                    username: widget.username,
                    rol: widget.rol,
                    roluser: widget.roluser,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: isSmallScreen ? 16 : 18,
              ),
              textStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emergency, size: 20, color: Colors.white),
                SizedBox(width: 10),
                Text('SOLICITUD DE EMERGENCIA'),
              ],
            ),
          ),
        ).animate().scale(delay: 900.ms),
      ],
    );
  }
}
