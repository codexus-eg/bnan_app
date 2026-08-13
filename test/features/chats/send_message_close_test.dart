import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not emit when send completes after close', () async {
    final repo = _PendingSendRepo();
    final cubit = SendMessageCubit(repo);
    final request = cubit.sendTextMessage(roomId: 'room', text: 'hello');

    await cubit.close();
    repo.complete();

    await expectLater(request, completes);
  });

  test('prevents duplicate submit while request is pending', () async {
    final repo = _PendingSendRepo();
    final cubit = SendMessageCubit(repo);
    final first = cubit.sendTextMessage(roomId: 'room', text: 'hello');
    final second = cubit.sendTextMessage(roomId: 'room', text: 'hello');

    expect(repo.calls, 1);
    repo.complete();
    await Future.wait([first, second]);
    await cubit.close();
  });
}

class _PendingSendRepo implements ChatRepo {
  final result = Completer<Either<Failure, ChatMessageResponseModel>>();
  int calls = 0;

  @override
  Future<Either<Failure, ChatMessageResponseModel>> sendMessage({
    required String roomId,
    String? text,
    List<String>? attachmentPaths,
  }) {
    calls++;
    return result.future;
  }

  void complete() => result.complete(Left(Failure(message: 'closed')));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
