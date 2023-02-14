import 'dart:io';

import 'package:bolisati/domain/api/failures/api.failures.dart';
import 'package:bolisati/domain/api/orders/personalaccidentorders/personalaccidentordermodel.dart';
import 'package:fpdart/fpdart.dart';

//ask ali about data type
abstract class IPersonalRepository {
  Future<Either<ApiFailures, dynamic>> getOffers(
      {required String? token,
      required int? age,
      required int? personaltypeid,
      required int? years,
      required int? amount});
  //place order
  Future<Either<ApiFailures, dynamic>> placeOrder({
    required String? addons,
    required PersonalAccidentOrderModel model,
    required String? token,
  });
  Future<Either<ApiFailures, dynamic>> attachFile(
      {required File file, required int orderid, required String apitoken});
  Future<Either<ApiFailures, dynamic>> getoccupation({String? apitoken});
}
