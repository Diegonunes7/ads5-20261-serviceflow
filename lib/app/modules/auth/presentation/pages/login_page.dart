import 'package:flutter/material.dart';

import '../../../../app_routes.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController senhaController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    senhaController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usando Scaffold e Padding para estruturar a tela
    return Scaffold(
      backgroundColor: Colors.white, // O fundo branco destaca o logo
      body: Center(
        child: SingleChildScrollView(
          // Evita quebra de layout com teclado
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- INSERÇÃO DO LOGO ---
              // Usando o widget reutilizável que criamos
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: AppLogo(width: double.infinity, height: 250),
              ),

              const SizedBox(height: 48), // Espaçamento entre logo e campos

              // Campos de texto e botão (reaproveitando exemplo anterior)
              CustomTextField(label: "E-mail", controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(
                  label: "Senha",
                  isPassword: true,
                  controller: senhaController),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.dashboard,
                ),
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
