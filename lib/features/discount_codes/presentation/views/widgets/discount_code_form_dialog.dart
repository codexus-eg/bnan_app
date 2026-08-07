import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_request.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_code_actions_cubit.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_code_actions_state.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_cubit.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_code_form_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showDiscountCodeForm(
  BuildContext context, {
  DiscountCodeModel? code,
}) => showDialog(
  context: context,
  builder: (_) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: context.read<DiscountCodeActionsCubit>()),
      BlocProvider.value(value: context.read<DiscountCodesCubit>()),
    ],
    child: DiscountCodeFormDialog(code: code),
  ),
);

class DiscountCodeFormDialog extends StatefulWidget {
  const DiscountCodeFormDialog({super.key, this.code});
  final DiscountCodeModel? code;

  @override
  State<DiscountCodeFormDialog> createState() => _DiscountCodeFormDialogState();
}

class _DiscountCodeFormDialogState extends State<DiscountCodeFormDialog> {
  late final code = TextEditingController(text: widget.code?.code);
  late final percentage = TextEditingController(
    text: widget.code?.percentage.toString(),
  );
  late final children = TextEditingController(
    text: widget.code?.childrenCount?.toString(),
  );
  late DiscountCodeType type = widget.code?.type ?? DiscountCodeType.dateRange;
  late bool active = widget.code?.isActive ?? true;
  late DateTime? start = widget.code?.startsAt?.toLocal();
  late DateTime? end = widget.code?.endsAt?.toLocal();
  String? error;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscountCodeActionsCubit, DiscountCodeActionsState>(
      listener: _listen,
      builder: (_, state) => CustomAppDialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(
                title: widget.code == null
                    ? S.of(context).addDiscountCode
                    : S.of(context).editDiscountCode,
              ),
              const SizedBox(height: 16),
              DiscountCodeFormFields(
                code: code,
                percentage: percentage,
                children: children,
                type: type,
                active: active,
                start: start,
                end: end,
                onType: (value) => setState(() {
                  type = value;
                  error = null;
                }),
                onActive: (value) => setState(() => active = value),
                onStart: (value) => setState(() {
                  start = value;
                  if (end?.isBefore(value) == true) end = null;
                }),
                onEnd: (value) => setState(() => end = value),
              ),
              if (error != null) ...[
                Text(error!, style: const TextStyle(color: ColorManager.red)),
                const SizedBox(height: 8),
              ],
              CustomAppButton(
                text: S.of(context).confirm,
                isLoading: state is DiscountCodeActionLoading,
                onPressed: state is DiscountCodeActionLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final validation = _validate();
    if (validation != null) return setState(() => error = validation);
    context.read<DiscountCodeActionsCubit>().save(
      DiscountCodeRequest(
        code: code.text,
        type: type,
        percentage: num.parse(percentage.text.trim()),
        isActive: active,
        startsAt: type == DiscountCodeType.dateRange ? start : null,
        endsAt: type == DiscountCodeType.dateRange ? _endOfDay(end!) : null,
        childrenCount: type == DiscountCodeType.children
            ? int.parse(children.text.trim())
            : null,
      ),
      id: widget.code?.id,
    );
  }

  String? _validate() {
    final s = S.of(context);
    if (code.text.trim().isEmpty) return s.discountCodeRequired;
    final value = num.tryParse(percentage.text.trim());
    if (value == null || value <= 0 || value > 100) {
      return s.invalidDiscountPercentage;
    }
    if (type == DiscountCodeType.dateRange && (start == null || end == null)) {
      return s.discountDatesRequired;
    }
    if (start != null && end != null && end!.isBefore(start!)) {
      return s.discountEndBeforeStart;
    }
    final count = int.tryParse(children.text.trim());
    if (type == DiscountCodeType.children && (count == null || count <= 0)) {
      return s.invalidChildrenCount;
    }
    return null;
  }

  void _listen(BuildContext context, DiscountCodeActionsState state) {
    if (state is DiscountCodeActionFailure) {
      setState(() => error = state.message);
    }
    if (state is! DiscountCodeSaved) return;
    if (state.code.id.isEmpty) {
      context.read<DiscountCodesCubit>().load();
    } else {
      context.read<DiscountCodesCubit>().upsert(state.code);
    }
    showCustomSnackBar(
      context,
      widget.code == null
          ? S.of(context).discountCodeCreated
          : S.of(context).discountCodeUpdated,
      true,
    );
    Navigator.pop(context);
  }

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  @override
  void dispose() {
    code.dispose();
    percentage.dispose();
    children.dispose();
    super.dispose();
  }
}
