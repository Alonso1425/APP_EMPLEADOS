import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConfidencialPage extends StatefulWidget {
  const ConfidencialPage({super.key});

  @override
  _ConfidencialPageState createState() => _ConfidencialPageState();
}

class _ConfidencialPageState extends State<ConfidencialPage> {
  final TextEditingController _mensajeController = TextEditingController();
  final TextEditingController _mensajeDenunciaController =
      TextEditingController();
  String? _categoria;
  bool _mostrarCamposAdicionales = false;

  final DateTime _fecha = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInformativeDialog();
    });
  }

  void _showInformativeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Información Importante",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              "Recuerda que cualquier denuncia realizada en esta sección es completamente confidencial y únicamente será enviada al área de Recursos Humanos y a la Dirección General de la empresa.",
              style: TextStyle(fontSize: 15)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cerrar",
                  style: TextStyle(
                      color: Colors.orange[900], fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Función para manejar el envío del formulario
  void _enviarFormulario() {
    if (_formKey.currentState?.validate() ?? false) {
      _resetFields();
      // Si es necesario, conecta con la base de datos o una API para guardar la información.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Envío exitoso",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(
                "Tu mensaje fue enviado correctamente para poder ser revisado por nuestro equipo correspondiente."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar",
                    style: TextStyle(
                        color: Colors.orange[900],
                        fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }
  }

  void _resetFields() {
    _mensajeController.clear();
    _mensajeDenunciaController.clear();
    setState(() {
      _categoria = null;
      _mostrarCamposAdicionales = false;
    });
  }

  void _actualizarCategoria(String? newValue) {
    setState(() {
      _categoria = newValue;
      _mostrarCamposAdicionales = _categoria == 'Denuncia';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Acércate',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
            .animate()
            .fadeIn(duration: 500.ms),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
        elevation: 4,
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
                    'Envía Denuncia o Sugerencia',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ).animate().fadeIn(duration: 500.ms),
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
                    enabled: false,
                  ),
                )
                    .animate()
                    .slideX(
                        begin: -1.0,
                        end: 0.0,
                        duration: 500.ms,
                        curve: Curves.easeOut)
                    .fadeIn(duration: 500.ms),
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
                    onChanged: _actualizarCategoria,
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
                )
                    .animate()
                    .slideX(
                        begin: -1.0,
                        end: 0.0,
                        duration: 500.ms,
                        curve: Curves.easeOut)
                    .fadeIn(duration: 500.ms),
                SizedBox(height: 20),

                // Campos adicionales para "Denuncia"
                Visibility(
                  visible: _mostrarCamposAdicionales,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildStyledContainer(
                        child: TextFormField(
                          decoration: _buildInputDecoration(
                              'Fecha en la que sucedió', Icons.date_range),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la fecha';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildStyledContainer(
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          decoration:
                              _buildInputDecoration('Área', Icons.location_on),
                          items: <String>[
                            'Inyección',
                            'Álmacen',
                            'Metales',
                            'Impresión',
                            'Corte',
                            'Serigrafia',
                            'Comedor',
                            'Baños',
                            'Oficina'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              // Actualiza el área seleccionada aquí
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Seleccione un área';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildStyledContainer(
                        child: TextFormField(
                          decoration: _buildInputDecoration(
                              'Hora Aproximada', Icons.access_time),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la hora aproximada';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildStyledContainer(
                        child: TextFormField(
                          decoration: _buildInputDecoration(
                              'Personas involucradas', Icons.person),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese los nombres de las personas involucradas';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Campo de mensaje para la denuncia
                      _buildStyledContainer(
                        child: TextFormField(
                          controller: _mensajeDenunciaController,
                          decoration: InputDecoration(
                            labelText: 'Mensaje',
                            icon: Icon(Icons.message, color: Colors.red),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText:
                                'Ménciona detalladamente el lugar y el suceso ocurrido. En caso de tener testigos, por favor propórciona sus nombres',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (_mostrarCamposAdicionales &&
                                (value == null || value.isEmpty)) {
                              return 'Por favor, detalla el suceso';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),

                // Campo de mensaje (se oculta si es "Denuncia")
                Visibility(
                  visible: !_mostrarCamposAdicionales,
                  child: _buildStyledContainer(
                    child: TextFormField(
                      controller: _mensajeController,
                      decoration:
                          _buildInputDecoration('Mensaje', Icons.message),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu mensaje';
                        }
                        return null;
                      },
                    ),
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(duration: 500.ms),
                ),
                SizedBox(height: 20),

                // Botón de enviar
                ElevatedButton(
                  onPressed: _enviarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[700],
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
                ).animate().scale(delay: 500.ms),
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
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    margin: EdgeInsets.only(bottom: 15),
    clipBehavior: Clip.antiAlias,
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
      padding: EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.red),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );
}
