import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:dartz/dartz.dart';

class ParentHomeRepoImpl implements ParentHomeRepo {
  const ParentHomeRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GetParentChildrenResponseModel>> getParentChildren() =>
      repoGuard(() async {
        final response = await apiConsumer.get(
          EndPoints.parentChildren,
          isProtected: true,
        );
        return GetParentChildrenResponseModel.fromJson(asMap(response));
      });
}
