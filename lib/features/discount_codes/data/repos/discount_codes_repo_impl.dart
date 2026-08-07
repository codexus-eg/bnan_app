import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_request.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_codes_parser.dart';
import 'package:bnan_app/features/discount_codes/data/repos/discount_codes_repo.dart';
import 'package:dartz/dartz.dart';

class DiscountCodesRepoImpl implements DiscountCodesRepo {
  const DiscountCodesRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getAll() => repoGuard(() async {
    final response = await api.get(
      EndPoints.adminDiscountCodes,
      isProtected: true,
    );
    return parseDiscountCodes(response);
  });

  @override
  getById(String id) => repoGuard(() async {
    final response = await api.get(
      EndPoints.adminDiscountCode(id),
      isProtected: true,
    );
    return parseDiscountCode(response);
  });

  @override
  create(DiscountCodeRequest request) => repoGuard(() async {
    final response = await api.post(
      EndPoints.adminDiscountCodes,
      data: request.toJson(),
      isProtected: true,
    );
    return parseDiscountCode(response);
  });

  @override
  update(String id, DiscountCodeRequest request) => repoGuard(() async {
    final response = await api.patch(
      EndPoints.adminDiscountCode(id),
      data: request.toJson(),
      isProtected: true,
    );
    return parseDiscountCode(response);
  });

  @override
  delete(String id) => repoGuard(() async {
    await api.delete(EndPoints.adminDiscountCode(id), isProtected: true);
    return unit;
  });
}
