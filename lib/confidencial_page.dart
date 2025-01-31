import 'package:flutter/material.dart';

class ConfidencialPage extends StatefulWidget {
  const ConfidencialPage({super.key});

  @override
  _ConfidencialPageState createState() => _ConfidencialPageState();
}

class _ConfidencialPageState extends State<ConfidencialPage> {
  final TextEditingController _mensajeController = TextEditingController();
  String _categoria = 'Denuncia'; // Valor por defecto
  final DateTime _fecha = DateTime.now(); // Fecha actual

  final _formKey = GlobalKey<FormState>();

  // Función para manejar el envío del formulario
  void _enviarFormulario() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí puedes agregar la lógica para enviar la denuncia/queja/sugerencia
      // Si es necesario, conecta con la base de datos o una API para guardar la información.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Envío exitoso",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text("Tu mensaje fue enviado correctamente."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Confidencialidad',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
        elevation: 4, // Ligera sombra para darle profundidad
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Envía tu Feedback',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Campo de fecha (automático)
                _buildStyledContainer(
                  child: TextFormField(
                    initialValue: _fecha
                        .toLocal()
                        .toString()
                        .split(' ')[0], // Formato: YYYY-MM-DD
                    decoration:
                        _buildInputDecoration('Fecha', Icons.calendar_today),
                    readOnly: true,
                    enabled: false, // Deshabilitado ya que es automático
                  ),
                ),
                SizedBox(height: 20),

                // Campo de categoría
                _buildStyledContainer(
                  child: DropdownButtonFormField<String>(
                    value: _categoria,
                    decoration:
                        _buildInputDecoration('Categoría', Icons.category),
                    items: <String>['Denuncia', 'Queja', 'Sugerencia']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _categoria = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona una categoría';
                      }
                      return null;
                    },
                    onTap: () {
                      setState(() {
                        _categoria = _categoria;
                      });
                    },
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                SizedBox(height: 20),

                // Campo de mensaje
                _buildStyledContainer(
                  child: TextFormField(
                    controller: _mensajeController,
                    decoration: _buildInputDecoration('Mensaje', Icons.message),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu mensaje';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Botón de enviar
                ElevatedButton(
                  onPressed: _enviarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[900],
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Container _buildStyledContainer({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding:
        EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Espacio mejorado
    margin: EdgeInsets.only(bottom: 15), // Espacio entre campos
    child: child,
  );
}

InputDecoration _buildInputDecoration(String labelText, IconData icon) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    prefixIcon: Padding(
      padding: EdgeInsets.all(8.0), // Espacio para el ícono
      child: Icon(icon, color: Colors.red),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15),
    ),
    contentPadding: EdgeInsets.symmetric(
        horizontal: 20, vertical: 16), // Espacio dentro del campo
  );
}
