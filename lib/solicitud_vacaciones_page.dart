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
      // Mostrar un mensaje de error si la fecha seleccionada es antes de la fecha mínima permitida
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Por favor selecciona una fecha con al menos 7 días hábiles de anticipación.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange[800],
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(10.0),
        ),
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
        _diasSolicitados.sort((a, b) => a.compareTo(b)); // Ordenar las fechas
        rangoFechaController.text = _diasSolicitados
            .map((e) => DateFormat('dd/MM/yyyy').format(e))
            .join(' - ');
      } else {
        rangoFechaController.clear();
      }
    });
  }

  //Calcular la fecha mínima permitida (7 días hábiles a partir de la fecha)
  DateTime calcularFechaMinima() {
    DateTime minDate = DateTime.now();
    int daysToAdd = 7;
    while (daysToAdd > 0) {
      minDate = minDate.add(Duration(days: 1));
      // Si el día no es sábado (6) ni domingo (7), restamos un día hábil
      if (minDate.weekday != DateTime.saturday &&
          minDate.weekday != DateTime.sunday) {
        daysToAdd--;
      }
    }
    return minDate;
  }

  // Función para enviar la solicitud
  Future<void> _enviarSolicitud() async {
    final url = Uri.parse(
        'http://192.168.1.99/api/vacaciones/enviar_solicitud_vacaciones.php');

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
  }

  //WIDGET PARA MOSTRAR MENSAJE DE ÉXITO
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
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // WIDGET PARA MOSTRAR MENSAJE DE ERROR
  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
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
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  //FUNCIÓN PARA LIMPIAR LOS CAMPOS
  void _resetFields() {
    setState(() {
      // Limpiar los campos "Días Seleccionados" y "Calendario"
      _diasSolicitados.clear();
      _diasSeleccionados = 0;
      _calendarFormat = CalendarFormat.month;
      rangoFechaController.clear();
    });
  }

  //WIDGET PARA MOSTRAR ALERTA DE INFORMACIÓN
  void _showInformativeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Información',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'La solicitud de vacaciones se debe de realizar con 7 días de hábiles de anticipación.'),
          actions: <Widget>[
            TextButton(
              child: Text('De Acuerdo',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600)),
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Solicitud de Vacaciones',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms), // Animación de fadeIn en el título
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formulario de Solicitud de Vacaciones',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms), // Animación de fadeIn en el título
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: dateController,
              label: 'Fecha de Solicitud',
              icon: Icons.today,
              readOnly: true,
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(
                    duration: 500.ms), // Animación de deslizamiento y fadeIn
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: usernameController,
              label: 'Nombre del Empleado',
              icon: Icons.person_outlined,
              readOnly: true,
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(
                    duration: 500.ms), // Animación de deslizamiento y fadeIn
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: rolController,
              label: 'Cargo que Desempeña',
              icon: Icons.business_center,
              readOnly: true,
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(
                    duration: 500.ms), // Animación de deslizamiento y fadeIn
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: roluserController,
              label: 'Área',
              icon: Icons.apartment,
              readOnly: true,
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(
                    duration: 500.ms), // Animación de deslizamiento y fadeIn
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Color del borde
                  width: 1.0, // Ancho del borde
                ),
                borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
              ),
              padding: EdgeInsets.all(8.0), // Espacio interior
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendario',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Agrega un espacio entre el texto y el calendario
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      // Resaltar los días que están en la lista de días solicitados
                      return _diasSolicitados.contains(day);
                    },
                    onDaySelected: _onDaySelected,
                    calendarFormat: _calendarFormat,
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.orange),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.orange),
                      headerPadding: EdgeInsets.symmetric(vertical: 8.0),
                      titleTextStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      selectedDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.teal[100],
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.teal[800],
                        fontWeight: FontWeight.bold,
                      ),
                      defaultTextStyle: TextStyle(
                        color: Colors.teal[600],
                      ),
                      weekendTextStyle: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    availableGestures: AvailableGestures.all,
                  ),
                ],
              ),
            )
                .animate()
                .slideX(
                    begin: 1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(
                    duration: 500.ms), // Animación de deslizamiento y fadeIn
            const SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Días Seleccionados:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                    width:
                        5), // Poner un poco de espacio entre el texto y los días seleccionados
                Expanded(
                  child: Text(
                    '$_diasSeleccionados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Limitar el texto a una línea y añadir "..." si es necesario
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms), // Animación de fadeIn
            const SizedBox(height: 16.0),

            _buildTextField(
              controller: rangoFechaController,
              label: 'Fechas Seleccionadas',
              icon: Icons.date_range,
              readOnly: true,
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(
                    duration: 500.ms), // Animación de deslizamiento y fadeIn
            const SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: _enviarSolicitud,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[700],
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Enviar Solicitud',
                  style: TextStyle(color: Colors.white)),
            ).animate().scale(delay: 500.ms),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SolicitudEmergenciaPage(
                          username: widget.username,
                          rol: widget.rol,
                          roluser: widget.roluser)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Solicitud de Emergencia',
                  style: TextStyle(color: Colors.white)),
            ).animate().scale(delay: 500.ms),
            SizedBox(height: 15.0),
            // Animación de escala en el botón
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      cursorColor: Colors.black,
    );
  }
}
