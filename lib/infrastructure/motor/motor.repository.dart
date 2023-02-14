import 'dart:io';

import 'package:bolisati/domain/api/failures/api.failures.dart';
import 'package:bolisati/domain/api/motor/model/motormodel.dart';
import 'package:bolisati/domain/api/motor/model/motororderdonemodel.dart';
import 'package:bolisati/domain/api/orders/motororders/cars/carmodel.dart';
import 'package:bolisati/domain/api/orders/motororders/motorordermodel.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/api/motor/contracts/i.motor.repository.dart';

class MotorRepository implements IMotorRepository {
  @override
  Future<Either<ApiFailures, dynamic>> attachFile(
      {required File file,
      required int orderid,
      required String apitoken}) async {
    var dio = Dio();
    dio.options.headers = {'Content-Type': "application/json"};
    final result = TaskEither<ApiFailures, dynamic>.tryCatch(() async {
      FormData formData = FormData.fromMap({
        "order_id": orderid,
        "file": await MultipartFile.fromFile(file.path, filename: file.path),
      });
      final result = await dio.post(
          "https://system.bolisati.com/api/V1/Motor/AttachFile?api_token=$apitoken",
          data: formData);

      if (result.data["AZSVR"] == "SUCCESS") {
        return result.data["FileURL"];
      } else {
        return const ApiFailures.internalError();
      }
    }, (error, stackTrace) {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.connectTimeout:
            return const ApiFailures.connnectionTimeOut();
          case DioErrorType.cancel:
            return const ApiFailures.cancel();
          case DioErrorType.response:
            return const ApiFailures.noResponse();
          default:
            return const ApiFailures.noResponse();
        }
      }
      return const ApiFailures.internalError();
    });
    return result.map((r) => r).run();
  }
  //done

  @override
  Future<Either<ApiFailures, dynamic>> getOffers(
      {String? token, int? vehiclemodelid, int? estimatedcarprice}) async {
    var dio = Dio();
    dio.options.headers = {'Content-Type': "application/json"};
    final result = TaskEither<ApiFailures, dynamic>.tryCatch(() async {
      final result = await dio.get(
        "https://system.bolisati.com/api/V1/Motor/GetOffers?vehicle_model_id=$vehiclemodelid&estimated_car_price=$estimatedcarprice&api_token=$token",
      );
      print(result.realUri);

      Map<String, dynamic> map = result.data;

      List<dynamic> data = map["Offers"];

      List<MotorOffersModel> offers =
          data.map((e) => MotorOffersModel.fromJson(e)).toList();
      if (result.data["AZSVR"] == "SUCCESS") {
        return offers;
      } else {
        return const ApiFailures.internalError();
      }
    }, (error, stackTrace) {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.connectTimeout:
            return const ApiFailures.connnectionTimeOut();
          case DioErrorType.cancel:
            return const ApiFailures.cancel();
          case DioErrorType.response:
            return const ApiFailures.noResponse();
          default:
            return const ApiFailures.noResponse();
        }
      }
      return const ApiFailures.internalError();
    });
    return result.map((r) => r).run();
  }

//done

  @override
  Future<Either<ApiFailures, dynamic>> placeOrder(
      {required MotorOrderModel motororder,
      required String? token,
      required String? addons}) async {
    var dio = Dio();
    dio.options.headers = {"Content-Type": "application/json"};

    final result = TaskEither<ApiFailures, dynamic>.tryCatch(() async {
      final result = await dio.get(
          """https://system.bolisati.com/api/V1/Motor/PlaceOrder?motor_insurance_id=${motororder.motor_insurance_id}&vehicle_model_id=${motororder.vehicle_model_id}&name=${motororder.name}&estimated_car_price=${motororder.estimated_car_price}&start_date=${motororder.start_date}&end_date=${motororder.end_date}&fuel_type=${motororder.fuel_type}&car_year=${motororder.car_year}&previous_accidents=${motororder.previous_accidents}$addons&api_token=$token""");
      print(result.realUri);
      if (result.data["AZSVR"] == "SUCCESS") {
        MotorOrderDoneModel model =
            MotorOrderDoneModel.fromJson(result.data["OrderDetails"]);
        return model;
      } else {
        return const ApiFailures.internalError();
      }
    }, (error, stackTrace) {
      print(error);
      if (error is DioError) {
        print(error.requestOptions.uri);
        switch (error.type) {
          case DioErrorType.connectTimeout:
            return const ApiFailures.connnectionTimeOut();
          case DioErrorType.cancel:
            return const ApiFailures.cancel();
          case DioErrorType.response:
            return const ApiFailures.noResponse();
          default:
            return const ApiFailures.noResponse();
        }
      }
      return const ApiFailures.internalError();
    });
    return result.map((r) => r).run();
  }

//done
  @override
  Future<Either<ApiFailures, dynamic>> getcars({String? apitoken}) {
    var dio = Dio();
    final result = TaskEither<ApiFailures, dynamic>.tryCatch(() async {
      final result = await dio.get(
          "https://system.bolisati.com/api/V1/Motor/GetCars?api_token=$apitoken");
      // print(result.data["Cars"] as List<CarModel>);
      Map<String, dynamic> map = result.data;
      List<dynamic> data = map["Cars"];
      List<CarModel> cars = data.map((e) => CarModel.fromJson(e)).toList();
      // List<CarModel> cars = result.data["Cars"];
      return cars;
    }, (error, stackTrace) {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.connectTimeout:
            return const ApiFailures.connnectionTimeOut();
          case DioErrorType.cancel:
            return const ApiFailures.cancel();
          case DioErrorType.response:
            return const ApiFailures.noResponse();
          default:
            return const ApiFailures.noResponse();
        }
      }
      return const ApiFailures.internalError();
    });
    return result.map((r) => r).run();
  }

  @override
  Future<Either<ApiFailures, dynamic>> setstatus(
      {String? token, String? status, String? orderid}) {
    var dio = Dio();
    final result = TaskEither<ApiFailures, dynamic>.tryCatch(() async {
      final result = await dio.get(
          "https://system.bolisati.com/api/V1/Motor/SetStatus?order_id=$orderid&status=$status&api_token=$token");

      return result.data;
    }, (error, stackTrace) {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.connectTimeout:
            return const ApiFailures.connnectionTimeOut();
          case DioErrorType.cancel:
            return const ApiFailures.cancel();
          case DioErrorType.response:
            return const ApiFailures.noResponse();
          default:
            return const ApiFailures.noResponse();
        }
      }
      return const ApiFailures.internalError();
    });
    return result.map((r) => r).run();
  }
}
