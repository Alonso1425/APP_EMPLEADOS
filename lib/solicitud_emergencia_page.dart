import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SolicitudEmergenciaPage extends StatefulWidget {
  final String username;
  final String rol;
  final String roluser;

  const SolicitudEmergenciaPage(
      {super.key, this.username = '', this.rol = '', this.roluser = ''});

  @override
  _SolicitudEmergenciaPageState createState() =>
      _SolicitudEmergenciaPageState();
}

class _SolicitudEmergenciaPageState extends State<SolicitudEmergenciaPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController rolController = TextEditingController();
  final TextEditingController roluserController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController rangoFechaController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int _diasSeleccionados = 0;
  final List<DateTime> _diasSolicitados = [];
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  String? dropdownValue;
  bool showOtherField = false;
  bool showOtherField2 = false;

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
      rolController.text = widget.rol;
      roluserController.text = widget.roluser;
    });
  }

  void _setDate() {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    dateController.text = currentDate;
  }

  // Función para manejar la selección de fechas individualmente
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_diasSolicitados.contains(selectedDay)) {
        _diasSolicitados.remove(selectedDay);
      } else {
        _diasSolicitados.add(selectedDay);
      }
      _diasSeleccionados = _diasSolicitados.length;
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

  //FUNCION SIMULADA PARA ENVIAR LA SOLICITUD
  void _enviarSolicitudEmergencia() {
    _resetfields();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Solicitud de Emergencia Enviada",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
              "Tu solicitud de vacaciones de emergencia fue enviada exitosamente para revisión y autorización."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Entendido",
                  style: TextStyle(color: Colors.orange[800])),
            ),
          ],
        );
      },
    );
  }

  void _resetfields() {
    setState(() {
      _diasSolicitados.clear();
      _diasSeleccionados = 0;
      rangoFechaController.clear();
      dropdownValue = null;
      showOtherField = false;
      showOtherField2 = false;
    });
  }

  //MENSAJE DE ALERTA DE INFORMACIÓN AL ENTRAR A LA PANTALLA
  void _showInformativeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Importante',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: Text(
              'Las vacaciones por emergencia solamente serán autorizadas cuando se trate de situaciones no previstas o de emergencia, tales como: Accidente, Enfermedad o Fallecimiento de un Familiar en primer o segundo grado.'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar',
                  style: TextStyle(
                      color: Colors.orange[900], fontWeight: FontWeight.bold)),
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
          'Solicitud de Vacaciones de Emergencia',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ).animate().fadeIn(duration: 500.ms),
        backgroundColor: Colors.yellow[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solicitud de Vacaciones de Emergencia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ).animate().fadeIn(duration: 500.ms),
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
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: usernameController,
              label: 'Nombre de Empleado',
              icon: Icons.person_outline,
              readOnly: true,
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(duration: 500.ms),
            SizedBox(height: 16.0),
            _buildTextField(
              controller: roluserController,
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
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: rolController,
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
                .fadeIn(duration: 500.ms),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
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
                  SizedBox(height: 10),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
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
                .fadeIn(duration: 500.ms),
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
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 20.0),

            DropdownButtonFormField<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  //dropdownValue = newValue!;
                  dropdownValue = newValue;
                  showOtherField = dropdownValue == "Otro";
                  showOtherField2 = dropdownValue == "Enfermedad";
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Emergencia',
                labelStyle: const TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                prefixIcon: Icon(Icons.warning, color: Colors.black),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              items: <String>[
                'Enfermedad',
                'Accidente',
                'Fallecimiento',
                'Otro'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 16.0),
            //
            Visibility(
              visible: showOtherField,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Por Favor Especifique el Motivo',
                  labelStyle: const TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  prefixIcon: Icon(Icons.info, color: Colors.black),
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            //
            //
            Visibility(
              visible: showOtherField2,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Parentesco / Relación con el Familiar',
                  labelStyle: const TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  prefixIcon: Icon(Icons.info, color: Colors.black),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                dropdownColor: Colors.white,
                value: null,
                onChanged: (String? newValue) {},
                items: <String>[
                  'Esposo(a) / Pareja',
                  'Padre / Madre',
                  'Hijo(a)',
                  'Hermano(a)',
                  'Abuelo(a)',
                  'Padre / Madre del esposo(a) / Pareja',
                  'Hijo(a) del esposo(a) / Pareja',
                  'Hermano(a) del esposo(a) / Pareja',
                  'Abuelo(a) del esposo(a) / Pareja',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: _enviarSolicitudEmergencia,
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
          ],
        ),
      ),
    );
  }

  //WIDGET DE CAMPOS DE FORMULARIO PARA DARLES UN DISEÑO
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
