import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class ParentHomeRepo {
  Future<Either<Failure, GetParentChildrenResponseModel>> getParentChildren();
}
