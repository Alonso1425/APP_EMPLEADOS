import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importar el paquete de animaciones

class ComunicadosPage extends StatelessWidget {
  const ComunicadosPage({super.key});

  // Función para ordenar los comunicados por fecha (del más reciente al más antiguo)
  List<Map<String, String>> _ordenarComunicadosPorFecha(
      List<Map<String, String>> comunicados) {
    return comunicados
      ..sort((a, b) {
        final fechaA = DateTime.parse(a['fecha']!);
        final fechaB = DateTime.parse(b['fecha']!);
        return fechaB.compareTo(fechaA); // Orden descendente
      });
  }

  @override
  Widget build(BuildContext context) {
    // Lista de comunicados simulados
    final List<Map<String, String>> comunicados = [
      {
        'titulo': 'Nuevo Beneficio de Vacaciones',
        'contenido':
            'Ahora puedes solicitar tus vacaciones con mayor facilidad.',
        'imagen': 'assets/img/Muestra.jpg',
        'fecha': '2025-01-27',
        'usuario': 'Brandon',
      },
      {
        'titulo': 'Mantenimiento del Sistema',
        'contenido':
            'El sistema estará fuera de servicio este viernes de 2:00 PM a 6:00 PM.',
        'imagen': 'assets/img/Muestra2.jpg',
        'fecha': '2025-01-25',
        'usuario': 'Karem',
      },
    ];

    // Ordenar los comunicados antes de mostrarlos
    final comunicadosOrdenados = _ordenarComunicadosPorFecha(comunicados);

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
