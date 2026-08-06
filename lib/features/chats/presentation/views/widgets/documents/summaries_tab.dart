import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_empty.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_failure.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_list.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_skeleton.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummariesTab extends StatelessWidget {
  const SummariesTab({super.key, required this.classroomId});
  final String classroomId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        ClassroomSummariesCubit,
        ClassroomDocumentsState<ClassroomSummaryItemModel>
      >(
        builder: (context, state) {
          final cubit = context.read<ClassroomSummariesCubit>();
          if (state is DocumentsInitial<ClassroomSummaryItemModel>) {
            return const SizedBox.shrink();
          }
          if (state is DocumentsLoading<ClassroomSummaryItemModel>) {
            return const DocumentsSkeleton();
          }
          if (state is DocumentsFailure<ClassroomSummaryItemModel>) {
            return DocumentsFailureView(
              message: state.message,
              retry: () => cubit.load(classroomId, refresh: true),
            );
          }
          if (state is DocumentsEmpty<ClassroomSummaryItemModel>) {
            return DocumentsEmptyView(
              title: S.of(context).noReportsAvailable,
              refresh: () => cubit.load(classroomId, refresh: true),
            );
          }
          final items =
              (state as DocumentsSuccess<ClassroomSummaryItemModel>).items;
          return DocumentsList(
            count: items.length,
            refresh: () => cubit.load(classroomId, refresh: true),
            builder: (_, index) => SummaryCard(item: items[index]),
          );
        },
      );
}
