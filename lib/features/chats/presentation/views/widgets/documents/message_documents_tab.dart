import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:bnan_app/features/chats/presentation/manager/message_documents_cubit.dart';
import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_empty.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_failure.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_list.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_skeleton.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/message_document_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageDocumentsTab extends StatelessWidget {
  const MessageDocumentsTab({super.key, required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        MessageDocumentsCubit,
        ClassroomDocumentsState<MessageDocumentItem>
      >(
        builder: (context, state) {
          final cubit = context.read<MessageDocumentsCubit>();
          if (state is DocumentsLoading || state is DocumentsInitial) {
            return const DocumentsSkeleton();
          }
          if (state is DocumentsFailure<MessageDocumentItem>) {
            return DocumentsFailureView(
              message: state.message,
              retry: () => cubit.load(roomId, refresh: true),
            );
          }
          if (state is DocumentsEmpty<MessageDocumentItem>) {
            return DocumentsEmptyView(
              title: S.of(context).noMessageDocumentsAvailable,
              refresh: () => cubit.load(roomId, refresh: true),
            );
          }
          final items = (state as DocumentsSuccess<MessageDocumentItem>).items;
          return DocumentsList(
            count: items.length,
            refresh: () => cubit.load(roomId, refresh: true),
            builder: (_, index) => MessageDocumentCard(item: items[index]),
          );
        },
      );
}
