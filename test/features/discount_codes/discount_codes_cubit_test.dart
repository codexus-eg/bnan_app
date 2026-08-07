import 'dart:async';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/repos/discount_codes_repo.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_cubit.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prevents duplicate loads and removes locally', () async {
    final repo = _Repo();
    final cubit = DiscountCodesCubit(repo);
    final first = cubit.load();
    final second = cubit.load();
    expect(repo.calls, 1);
    repo.completer.complete(const Right([_code]));
    await Future.wait([first, second]);
    cubit.remove('1');
    expect((cubit.state as DiscountCodesSuccess).codes, isEmpty);
    await cubit.close();
  });
}

const _code = DiscountCodeModel(
  id: '1',
  code: 'CODE',
  type: DiscountCodeType.children,
  percentage: 10,
  isActive: true,
  childrenCount: 2,
);

class _Repo implements DiscountCodesRepo {
  int calls = 0;
  final completer = Completer<Either<Failure, List<DiscountCodeModel>>>();

  @override
  Future<Either<Failure, List<DiscountCodeModel>>> getAll() {
    calls++;
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
