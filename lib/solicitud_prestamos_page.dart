// archivo: solicitud_prestamos_page.dart
import 'package:flutter/material.dart';

class SolicitudPrestamosPage extends StatefulWidget {
  const SolicitudPrestamosPage({super.key});

  @override
  _SolicitudPrestamosPageState createState() => _SolicitudPrestamosPageState();
}

class _SolicitudPrestamosPageState extends State<SolicitudPrestamosPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  Future<void> submitLoanRequest() async {
    if (amountController.text.isEmpty ||
        purposeController.text.isEmpty ||
        durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, llena todos los campos.')),
      );
      return;
    }

    // Aquí puedes agregar la lógica para enviar la solicitud de préstamo al servidor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Solicitud de Préstamo Enviada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de Préstamos'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formulario de Solicitud de Préstamo',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: amountController,
              label: 'Monto del Préstamo',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: purposeController,
              label: 'Propósito del Préstamo',
              icon: Icons.description,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: durationController,
              label: 'Duración del Préstamo (en meses)',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: submitLoanRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60.0, vertical: 18.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
                child: const Text('Enviar Solicitud'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
