import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_animate/flutter_animate.dart'; // Importar el paquete de animaciones

class ComunicadosAdmiPage extends StatefulWidget {
  const ComunicadosAdmiPage({super.key});

  @override
  _ComunicadosAdmiPageState createState() => _ComunicadosAdmiPageState();
}

class _ComunicadosAdmiPageState extends State<ComunicadosAdmiPage> {
  final List<Map<String, String>> comunicadosadmi = [
    {
      'titulo': 'Mantenimiento del Sistema',
      'contenido':
          'El sistema estará fuera de servicio este viernes de 2:00 PM a 6:00 PM.',
      'imagen': 'assets/img/Muestra2.jpg',
      'fecha': '2025-01-31',
      'usuario': 'Jorge Alberto',
    },
    {
      'titulo': 'Reunión General',
      'contenido':
          'Habrá una reunión general el próximo lunes en la sala de conferencias.',
      'imagen': 'assets/img/Muestra.jpg',
      'fecha': '2025-01-30',
      'usuario': 'Araceli',
    },
  ];

  final ImagePicker _picker = ImagePicker();

  void _addComunicado(Map<String, String> newComunicado) {
    setState(() {
      comunicadosadmi.add(newComunicado);
    });
  }

  void _navigateToAddComunicado() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddComunicadoForm(),
      ),
    );

    if (result != null) {
      _addComunicado(result);
    }
  }

  // Función para ordenar los comunicados por fecha (del más reciente al más antiguo)
  List<Map<String, String>> _ordenarComunicadosPorFecha() {
    return comunicadosadmi
      ..sort((a, b) {
        final fechaA = DateTime.parse(a['fecha']!);
        final fechaB = DateTime.parse(b['fecha']!);
        return fechaB.compareTo(fechaA); // Orden descendente
      });
  }

  @override
  Widget build(BuildContext context) {
    // Ordenar los comunicados antes de mostrarlos
    final comunicadosOrdenados = _ordenarComunicadosPorFecha();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Comunicados Importantes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms), // Animación de fadeIn en el título
        backgroundColor: Colors.yellow[900],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: comunicadosOrdenados.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final comunicado = comunicadosOrdenados[index];
          return Card(
            color: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comunicado['titulo']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    comunicado['contenido']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Publicado por: ${comunicado['usuario']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  comunicado['imagen']!.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                  imageUrls: [comunicado['imagen']!],
                                ),
                              ),
                            );
                          },
                          child: comunicado['imagen']!.startsWith('assets/')
                              ? Image.asset(comunicado['imagen']!)
                              : Image.network(
                                  comunicado['imagen']!,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      'Error al cargar la imagen',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      comunicado['fecha']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .slideX(
                  begin: 1.0, end: 0.0, duration: 500.ms, curve: Curves.easeOut)
              .fadeIn(duration: 500.ms); // Animación de deslizamiento y fadeIn
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddComunicado,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms), // Animación de escala en el botón
    );
  }
}

class AddComunicadoForm extends StatefulWidget {
  const AddComunicadoForm({super.key});

  @override
  _AddComunicadoFormState createState() => _AddComunicadoFormState();
}

class _AddComunicadoFormState extends State<AddComunicadoForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void _showConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Comunicado publicado con éxito',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Nuevo Comunicado',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms), // Animación de fadeIn en el título
        backgroundColor: Colors.yellow[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de Título
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.title, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              )
                  .animate()
                  .slideX(
                      begin: -1.0,
                      end: 0.0,
                      duration: 500.ms,
                      curve: Curves.easeOut)
                  .fadeIn(
                      duration: 500.ms), // Animación de deslizamiento y fadeIn
              const SizedBox(height: 20),

              // Campo de Contenido
              TextFormField(
                controller: _contenidoController,
                decoration: InputDecoration(
                  labelText: 'Contenido',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  prefixIcon:
                      const Icon(Icons.description, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
              )
                  .animate()
                  .slideX(
                      begin: -1.0,
                      end: 0.0,
                      duration: 500.ms,
                      curve: Curves.easeOut)
                  .fadeIn(
                      duration: 500.ms), // Animación de deslizamiento y fadeIn
              const SizedBox(height: 20),

              // Campo de Fecha (automático)
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  prefixIcon:
                      const Icon(Icons.calendar_today, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                initialValue: _formatDate(DateTime.now()),
              )
                  .animate()
                  .slideX(
                      begin: -1.0,
                      end: 0.0,
                      duration: 500.ms,
                      curve: Curves.easeOut)
                  .fadeIn(
                      duration: 500.ms), // Animación de deslizamiento y fadeIn
              const SizedBox(height: 20),

              // Selección de Imagen
              _image == null
                  ? ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image, color: Colors.white),
                      label: const Text(
                        'Seleccionar Imagen',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[900],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  : Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.change_circle,
                                  color: Colors.white),
                              label: const Text(
                                'Cambiar Imagen',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
              const SizedBox(height: 20),

              // Botón de Publicar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newComunicado = {
                      'titulo': _tituloController.text,
                      'contenido': _contenidoController.text,
                      'imagen': _image?.path ?? '',
                      'fecha': _formatDate(DateTime.now()),
                      'usuario': 'Usuario Actual', // Simulación del usuario
                    };
                    Navigator.pop(context, newComunicado);
                    _showConfirmation(); // Mostrar mensaje de confirmación
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[900],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Publicar Comunicado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  .animate()
                  .slideX(
                      begin: -1.0,
                      end: 0.0,
                      duration: 500.ms,
                      curve: Curves.easeOut)
                  .fadeIn(
                      duration: 500.ms), // Animación de deslizamiento y fadeIn
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewer(
      {super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: imageUrls[index].startsWith('assets/')
                ? AssetImage(imageUrls[index])
                : NetworkImage(imageUrls[index]) as ImageProvider,
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 1.5,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
