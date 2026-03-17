import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComunicadosPage extends StatelessWidget {
  const ComunicadosPage({super.key, required String userId});

  // Paleta de colores profesional
  final Color _primaryColor = const Color(0xFF2C3E50);
  final Color _secondaryColor = const Color(0xFF3498DB);
  final Color _accentColor = const Color(0xFFE74C3C);
  final Color _successColor = const Color(0xFF27AE60);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2C3E50);
  final Color _hintColor = const Color(0xFF7F8C8D);

  // Función para ordenar los comunicados por fecha
  List<Map<String, String>> _ordenarComunicadosPorFecha(
      List<Map<String, String>> comunicados) {
    return comunicados
      ..sort((a, b) {
        final fechaA = DateTime.parse(a['fecha']!);
        final fechaB = DateTime.parse(b['fecha']!);
        return fechaB.compareTo(fechaA);
      });
  }

  // Función para formatear la fecha
  String _formatearFecha(String fecha) {
    final DateTime parsedDate = DateTime.parse(fecha);
    final List<String> meses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${parsedDate.day} ${meses[parsedDate.month - 1]} ${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Lista de comunicados simulados
    final List<Map<String, String>> comunicados = [
      {
        'titulo': 'Nuevo Beneficio de Vacaciones',
        'contenido':
            'Ahora puedes solicitar tus vacaciones con mayor facilidad a través del sistema interno. Consulta con tu supervisor para más información.',
        'imagen': 'assets/img/Muestra.jpg',
        'fecha': '2025-01-27',
        'usuario': 'Brandon García',
        'departamento': 'Recursos Humanos',
      },
      {
        'titulo': 'Mantenimiento del Sistema',
        'contenido':
            'El sistema estará fuera de servicio este viernes de 2:00 PM a 6:00 PM para mantenimiento programado. Por favor, guarde su trabajo con anticipación.',
        'imagen': 'assets/img/Muestra2.jpg',
        'fecha': '2025-01-25',
        'usuario': 'Karem Martínez',
        'departamento': 'Sistemas Informáticos',
      },
      {
        'titulo': 'Capacitación de Seguridad',
        'contenido':
            'Se programará una capacitación obligatoria sobre protocolos de seguridad para todo el personal. Fechas por confirmar.',
        'imagen': '',
        'fecha': '2025-01-20',
        'usuario': 'Carlos Rodríguez',
        'departamento': 'Seguridad Industrial',
      },
    ];

    final comunicadosOrdenados = _ordenarComunicadosPorFecha(comunicados);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Comunicados Importantes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(duration: 500.ms),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _secondaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: _secondaryColor.withOpacity(0.2)),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.announcement_outlined,
                  size: 40,
                  color: _secondaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mantente Informado',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Últimas noticias y anuncios de la empresa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: _hintColor,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),

          // Contador de comunicados
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${comunicadosOrdenados.length} Comunicado${comunicadosOrdenados.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.update, size: 16, color: _secondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Actualizado',
                        style: TextStyle(
                          fontSize: 12,
                          color: _secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 700.ms),

          // Lista de comunicados
          Expanded(
            child: ListView.builder(
              itemCount: comunicadosOrdenados.length,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 20,
                vertical: 8,
              ),
              itemBuilder: (context, index) {
                final comunicado = comunicadosOrdenados[index];
                final bool tieneImagen = comunicado['imagen']!.isNotEmpty;

                return _buildComunicadoCard(
                  context: context,
                  comunicado: comunicado,
                  tieneImagen: tieneImagen,
                  isSmallScreen: isSmallScreen,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComunicadoCard({
    required BuildContext context,
    required Map<String, String> comunicado,
    required bool tieneImagen,
    required bool isSmallScreen,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: _cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tieneImagen
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(
                        imageUrls: [comunicado['imagen']!],
                      ),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con fecha y etiqueta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: _secondaryColor),
                          const SizedBox(width: 6),
                          Text(
                            _formatearFecha(comunicado['fecha']!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index == 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: _accentColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          'NUEVO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _accentColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Título
                Text(
                  comunicado['titulo']!,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Contenido
                Text(
                  comunicado['contenido']!,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 16,
                    color: _textColor.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Imagen (si existe)
                if (tieneImagen) ...[
                  Container(
                    height: isSmallScreen ? 180 : 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: comunicado['imagen']!.startsWith('assets/')
                              ? Image.asset(
                                  comunicado['imagen']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.network(
                                  comunicado['imagen']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image,
                                              size: 40, color: _hintColor),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Imagen no disponible',
                                            style: TextStyle(color: _hintColor),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca la imagen para ampliar',
                    style: TextStyle(
                      fontSize: 12,
                      color: _hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Información del publicador
                Container(
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
                          color: _secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comunicado['usuario']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textColor,
                              ),
                            ),
                            Text(
                              comunicado['departamento'] ?? 'Departamento',
                              style: TextStyle(
                                fontSize: 12,
                                color: _hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideX(
          begin: 1.0,
          end: 0.0,
          duration: 500.ms + (index * 100).ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 600.ms + (index * 100).ms);
  }
}

class ImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: imageUrls[index].startsWith('assets/')
                ? AssetImage(imageUrls[index])
                : NetworkImage(imageUrls[index]) as ImageProvider,
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
