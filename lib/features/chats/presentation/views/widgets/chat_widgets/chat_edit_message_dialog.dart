import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool> showEditChatMessageDialog(
  BuildContext context,
  ChatMessageModel message,
) async {
  final cubit = context.read<GetRoomMessagesCubit>();
  final edited = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: cubit,
      child: CustomAppDialog(
        width: 340,
        child: _ChatEditDialogContent(message: message),
      ),
    ),
  );
  return edited == true;
}

class _ChatEditDialogContent extends StatefulWidget {
  const _ChatEditDialogContent({required this.message});
  final ChatMessageModel message;

  @override
  State<_ChatEditDialogContent> createState() => _ChatEditDialogContentState();
}

class _ChatEditDialogContentState extends State<_ChatEditDialogContent> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;
    final newText = _controller.text.trim();
    if (newText == widget.message.text.trim()) {
      Navigator.pop(context, false);
      return;
    }
    setState(() => _isLoading = true);
    final error = await context.read<GetRoomMessagesCubit>().editMessage(
      messageId: widget.message.id,
      text: newText,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (error != null) {
      showCustomSnackBar(context, error, false);
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              s.edit,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold16(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              maxLines: 4,
              minLines: 1,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorManager.white,
                hintText: s.typeMessage,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorManager.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorManager.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorManager.mainColor14),
                ),
              ),
              validator: (val) =>
                  val == null || val.trim().isEmpty ? s.fieldRequired : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    text: s.cancel,
                    height: 44,
                    backgroundColor: ColorManager.greyECE,
                    textColor: ColorManager.grey7A7C,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomAppButton(
                    text: s.save,
                    height: 44,
                    isLoading: _isLoading,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
