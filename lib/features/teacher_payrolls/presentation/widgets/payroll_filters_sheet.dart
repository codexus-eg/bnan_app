import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_date_formatter.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_filters.dart';

class PayrollFiltersSheet extends StatefulWidget {
  const PayrollFiltersSheet({
    super.key,
    required this.initial,
    required this.teachers,
  });
  final PayrollFilters initial;
  final List<PayrollTeacherModel> teachers;
  @override
  State<PayrollFiltersSheet> createState() => _PayrollFiltersSheetState();
}

class _PayrollFiltersSheetState extends State<PayrollFiltersSheet> {
  late DateTime from = widget.initial.from, to = widget.initial.to;
  String? status, teacherId;
  @override
  void initState() {
    super.initState();
    status = widget.initial.status;
    teacherId = widget.initial.teacherId;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  s.payrollFilterAction,
                  style: StylesManager.styleBold18(context),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: s.payrollFromDate,
                controller: TextEditingController(
                  text: PayrollDateFormatter.field(from),
                ),
                readOnly: true,
                onTap: () async {
                  final value = await AppPickers.pickDate(
                    context: context,
                    initialDate: from,
                    firstDate: DateTime(2020),
                  );
                  if (value != null) {
                    setState(() {
                      from = value;
                      if (to.isBefore(from)) to = from;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: s.payrollToDate,
                controller: TextEditingController(
                  text: PayrollDateFormatter.field(to),
                ),
                readOnly: true,
                onTap: () async {
                  final value = await AppPickers.pickDate(
                    context: context,
                    initialDate: to,
                    firstDate: from,
                  );
                  if (value != null) setState(() => to = value);
                },
              ),
              const SizedBox(height: 12),
              CustomDropdownFormField(
                label: s.payrollStatus,
                value: status,
                hint: s.payrollAllStatuses,
                items: const [
                  'draft',
                  'sent',
                  'payment_pending',
                  'paid',
                  'cancelled',
                  'unprepared',
                ],
                itemsLabels: {
                  'draft': s.payrollDraft,
                  'sent': s.payrollSent,
                  'payment_pending': s.payrollPaymentPending,
                  'paid': s.payrollPaid,
                  'cancelled': s.payrollCancelled,
                  'unprepared': s.payrollUnprepared,
                },
                onChanged: (v) => status = v,
              ),
              const SizedBox(height: 12),
              if (widget.teachers.isNotEmpty)
                CustomDropdownFormField(
                  label: s.selectTeacher,
                  value: teacherId,
                  hint: s.payrollAllTeachers,
                  items: widget.teachers.map((e) => e.id).toList(),
                  itemsLabels: {
                    for (final t in widget.teachers) t.id: t.fullName,
                  },
                  onChanged: (v) => teacherId = v,
                ),
              const SizedBox(height: 20),
              CustomAppButton(
                text: s.payrollApplyFilters,
                onPressed: () => Navigator.pop(
                  context,
                  PayrollFilters(
                    from: from,
                    to: to,
                    status: status,
                    teacherId: teacherId,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Navigator.pop(
                  context,
                  PayrollFilters(
                    from: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      1,
                    ),
                    to: DateTime.now(),
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Text(
                    s.payrollResetFilters,
                    style: StylesManager.styleBold14(
                      context,
                    ).copyWith(color: ColorManager.mainColor15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
