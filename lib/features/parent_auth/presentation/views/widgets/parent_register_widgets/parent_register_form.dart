import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_contact_fields.dart';
import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_password_field.dart';
import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_submit_button.dart';
import 'package:bnan_app/features/parent_auth/presentation/models/parent_registration_flow_args.dart';
import 'package:flutter/material.dart';

class ParentRegisterForm extends StatefulWidget {
  const ParentRegisterForm({super.key, required this.args});

  final ParentRegistrationFlowArgs args;

  @override
  State<ParentRegisterForm> createState() => _ParentRegisterFormState();
}

class _ParentRegisterFormState extends State<ParentRegisterForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late final TextEditingController emailController;
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.args.initialEmail);
    passwordController = TextEditingController(
      text: widget.args.initialPassword,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ParentRegisterContactFields(
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
            whatsappController: whatsappController,
          ),
          const SizedBox(height: 16),
          ParentRegisterPasswordField(controller: passwordController),
          const SizedBox(height: 16),
          ParentRegisterSubmitButton(
            flowArgs: widget.args,
            formKey: formKey,
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
            whatsappController: whatsappController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
