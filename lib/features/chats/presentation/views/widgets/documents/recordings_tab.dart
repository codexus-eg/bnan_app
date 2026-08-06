import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_empty.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_failure.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_list.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_skeleton.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/recording_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingsTab extends StatelessWidget {
  const RecordingsTab({super.key, required this.classroomId});
  final String classroomId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        ClassroomRecordingsCubit,
        ClassroomDocumentsState<ClassroomRecordingModel>
      >(
        builder: (context, state) {
          final cubit = context.read<ClassroomRecordingsCubit>();
          if (state is DocumentsLoading || state is DocumentsInitial) {
            return const DocumentsSkeleton();
          }
          if (state is DocumentsFailure<ClassroomRecordingModel>) {
            return DocumentsFailureView(
              message: state.message,
              retry: () => cubit.load(classroomId, refresh: true),
            );
          }
          if (state is DocumentsEmpty<ClassroomRecordingModel>) {
            return DocumentsEmptyView(
              title: S.of(context).noRecordingsAvailable,
              refresh: () => cubit.load(classroomId, refresh: true),
            );
          }
          final items =
              (state as DocumentsSuccess<ClassroomRecordingModel>).items;
          return DocumentsList(
            count: items.length,
            refresh: () => cubit.load(classroomId, refresh: true),
            builder: (_, index) => RecordingCard(item: items[index]),
          );
        },
      );
}
