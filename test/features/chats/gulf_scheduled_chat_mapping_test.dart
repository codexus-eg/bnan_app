import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('due Gulf lesson without chatRoomId maps to its room', () async {
    final cubit = _cubit(
      _gulfSuccess(_schedule(_dueTimes())),
      _roomsSuccess([_room('room', subject: 'subject-a')]),
    );

    await cubit.loadScheduledLessons();

    expect(cubit.state.scheduledChatRoomIds, {'room'});
    expect(cubit.state.isScheduledChat('room'), isTrue);
    await cubit.close();
  });

  test('schedule may arrive before rooms', () async {
    final gulf = Completer<Either<Failure, GulfSchedulesResponse>>();
    final rooms = Completer<Either<Failure, ChatRoomsResponseModel>>();
    final cubit = _cubit(gulf.future, rooms.future);

    final loading = cubit.loadScheduledLessons();
    gulf.complete(Right(_schedule(_dueTimes())));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.scheduledChatRoomIds, isEmpty);
    rooms.complete(Right(_rooms([_room('room', subject: 'subject-a')])));
    await loading;

    expect(cubit.state.scheduledChatRoomIds, {'room'});
    await cubit.close();
  });

  test('rooms may arrive before schedule', () async {
    final gulf = Completer<Either<Failure, GulfSchedulesResponse>>();
    final rooms = Completer<Either<Failure, ChatRoomsResponseModel>>();
    final cubit = _cubit(gulf.future, rooms.future);

    final loading = cubit.loadScheduledLessons();
    rooms.complete(Right(_rooms([_room('room', subject: 'subject-a')])));
    await Future<void>.delayed(Duration.zero);
    gulf.complete(Right(_schedule(_dueTimes())));
    await loading;

    expect(cubit.state.scheduledChatRoomIds, {'room'});
    await cubit.close();
  });

  test('Gulf lesson outside the current window is not scheduled', () async {
    final cubit = _cubit(
      _gulfSuccess(_schedule(_outsideTimes())),
      _roomsSuccess([_room('room', subject: 'subject-a')]),
    );

    await cubit.loadScheduledLessons();

    expect(cubit.state.scheduledChatRoomIds, isEmpty);
    await cubit.close();
  });

  test('classroomSubjectId prevents choosing another subject room', () async {
    final cubit = _cubit(
      _gulfSuccess(_schedule(_dueTimes())),
      _roomsSuccess([
        _room('wrong-room', subject: 'subject-b'),
        _room('right-room', subject: 'subject-a'),
      ]),
    );

    await cubit.loadScheduledLessons();

    expect(cubit.state.scheduledChatRoomIds, {'right-room'});
    await cubit.close();
  });
}

StartSessionCubit _cubit(
  Future<Either<Failure, GulfSchedulesResponse>> gulf,
  Future<Either<Failure, ChatRoomsResponseModel>> rooms,
) => StartSessionCubit(
  _StartRepo(),
  _GulfRepo(gulf),
  _TableRepo(),
  _ChatRepo(rooms),
);

Future<Either<Failure, GulfSchedulesResponse>> _gulfSuccess(
  GulfSchedulesResponse schedule,
) async => Right(schedule);

Future<Either<Failure, ChatRoomsResponseModel>> _roomsSuccess(
  List<ChatRoomSummaryModel> rooms,
) async => Right(_rooms(rooms));

ChatRoomsResponseModel _rooms(List<ChatRoomSummaryModel> rooms) =>
    ChatRoomsResponseModel(success: true, results: rooms.length, rooms: rooms);

GulfSchedulesResponse _schedule((String, String) times) =>
    GulfSchedulesResponse(
      success: true,
      data: GulfSchedulesData(
        classrooms: [
          GulfClassroom(
            id: 'classroom',
            name: 'Classroom',
            classroomSubject: 'subject-a',
            schedule: GulfSchedule(
              id: 'schedule',
              classroomSubject: 'subject-a',
              isActive: true,
              entries: [
                GulfScheduleEntry(
                  day: _weekday(DateTime.now().weekday),
                  startTime: times.$1,
                  endTime: times.$2,
                  classroomSubjectId: 'subject-a',
                ),
              ],
            ),
          ),
        ],
      ),
    );

ChatRoomSummaryModel _room(String id, {required String subject}) =>
    ChatRoomSummaryModel(
      id: id,
      type: 'classroom',
      displayName: 'Room',
      subtitle: '',
      classroomId: 'classroom',
      classroomSubjectId: subject,
    );

(String, String) _dueTimes() {
  final minutes = DateTime.now().hour * 60 + DateTime.now().minute;
  final start = minutes < 23 * 60 ? minutes + 10 : minutes - 10;
  return (_time(start), _time((start + 60).clamp(0, 23 * 60 + 59)));
}

(String, String) _outsideTimes() {
  final minutes = DateTime.now().hour * 60 + DateTime.now().minute;
  if (minutes < 22 * 60) return (_time(minutes + 60), _time(minutes + 120));
  return ('00:00', _time(minutes - 60));
}

String _time(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

String _weekday(int value) => switch (value) {
  DateTime.saturday => 'saturday',
  DateTime.sunday => 'sunday',
  DateTime.monday => 'monday',
  DateTime.tuesday => 'tuesday',
  DateTime.wednesday => 'wednesday',
  DateTime.thursday => 'thursday',
  _ => 'friday',
};

class _GulfRepo implements GulfScheduleRepo {
  _GulfRepo(this.result);
  final Future<Either<Failure, GulfSchedulesResponse>> result;

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule({
    String? studentId,
  }) => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ChatRepo implements ChatRepo {
  _ChatRepo(this.result);
  final Future<Either<Failure, ChatRoomsResponseModel>> result;

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TableRepo implements TableManagementRepo {
  @override
  Future<Either<Failure, EgyptianScheduleWeek>>
  getMyEgyptianDigitalSchedule() async => const Right(EgyptianScheduleWeek());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StartRepo implements StartSessionRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
