import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComunicadosAdmiPage extends StatefulWidget {
  final String username;

  const ComunicadosAdmiPage({super.key, required this.username});

  @override
  _ComunicadosAdmiPageState createState() => _ComunicadosAdmiPageState();
}

class _ComunicadosAdmiPageState extends State<ComunicadosAdmiPage> {
  final TextEditingController usernameController = TextEditingController();
  List<Map<String, dynamic>> comunicadosadmi = [];
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComunicados().then((comunicados) {
      setState(() {
        comunicadosadmi = comunicados;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener los comunicados: $error');
    });
  }

  Future<void> _loadComunicados() async {
    final comunicados = await fetchComunicados();
    setState(() {
      comunicadosadmi = comunicados;
    });
  }

  Future<List<Map<String, dynamic>>> fetchComunicados() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.149/api/comunicados/obtener_comunicados.php'));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception(
              'Error al cargar los comunicados: ${data['message']}');
        }
      } else {
        throw Exception('Respuesta vacía del servidor');
      }
    } else {
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<void> addComunicado(Map<String, String> newComunicado) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.149/api/comunicados/crear_comunicado.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newComunicado),
    );

    if (response.statusCode == 200) {
      print('Comunicado agregado con éxito');
    } else {
      throw Exception('Error al agregar el comunicado');
    }
  }

  void _addComunicado(Map<String, String> newComunicado) async {
    await addComunicado(newComunicado);
    _loadComunicados();
  }

  void _navigateToAddComunicado() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddComunicadoForm(
          username: widget.username,
        ),
      ),
    );

    if (result != null) {
      _addComunicado(result);
    }
  }

  List<Map<String, dynamic>> _ordenarComunicadosPorFecha() {
    return comunicadosadmi
      ..sort((a, b) {
        final fechaA = DateTime.parse(a['fecha']!);
        final fechaB = DateTime.parse(b['fecha']!);
        return fechaB.compareTo(fechaA); // Orden descendente
      });
  }

  @override
  Widget build(BuildContext context) {
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
        ).animate().fadeIn(duration: 500.ms),
        backgroundColor: Colors.yellow[900],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blueGrey[600]))
          : ListView.builder(
              itemCount: comunicadosOrdenados.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final comunicado = comunicadosOrdenados[index];
                return Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
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
                        comunicado['imagen'] != null &&
                                comunicado['imagen'].isNotEmpty
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
                                child: Image.network(
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
                        begin: 1.0,
                        end: 0.0,
                        duration: 500.ms,
                        curve: Curves.easeOut)
                    .fadeIn(duration: 500.ms);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddComunicado,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }
}

class AddComunicadoForm extends StatefulWidget {
  final String username;
  const AddComunicadoForm({super.key, required this.username});

  @override
  _AddComunicadoFormState createState() => _AddComunicadoFormState();
}

class _AddComunicadoFormState extends State<AddComunicadoForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final username = TextEditingController();
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
        ).animate().fadeIn(duration: 500.ms),
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
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
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
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
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
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
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
                      .fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newComunicado = {
                      'titulo': _tituloController.text,
                      'contenido': _contenidoController.text,
                      'imagen': _image?.path ?? '',
                      'fecha': _formatDate(DateTime.now()),
                      'usuario': widget.username, // Simulación del usuario
                    };
                    Navigator.pop(context, newComunicado);
                    _showConfirmation();
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
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final List<Uint8List> imageUrls;
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
            imageProvider: NetworkImage(imageUrls[index] as String),
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
