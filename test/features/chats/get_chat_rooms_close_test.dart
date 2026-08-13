import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not emit when rooms load completes after close', () async {
    final repo = _PendingRoomsRepo();
    final cubit = GetChatRoomsCubit(repo);
    final request = cubit.getChatRooms();

    await cubit.close();
    repo.complete();

    await expectLater(request, completes);
  });
}

class _PendingRoomsRepo implements ChatRepo {
  final response = Completer<Either<Failure, ChatRoomsResponseModel>>();

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() =>
      response.future;

  void complete() => response.complete(
    const Right(ChatRoomsResponseModel(success: true, results: 0, rooms: [])),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
