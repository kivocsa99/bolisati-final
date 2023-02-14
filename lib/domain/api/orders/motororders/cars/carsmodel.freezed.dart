// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carsmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CarsModel _$CarsModelFromJson(Map<String, dynamic> json) {
  return _CarsModel.fromJson(json);
}

/// @nodoc
mixin _$CarsModel {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  int? get vehicle_make_id => throw _privateConstructorUsedError;
  String? get created_at => throw _privateConstructorUsedError;
  String? get updated_at => throw _privateConstructorUsedError;
  String? get deleted_at => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CarsModelCopyWith<CarsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarsModelCopyWith<$Res> {
  factory $CarsModelCopyWith(CarsModel value, $Res Function(CarsModel) then) =
      _$CarsModelCopyWithImpl<$Res, CarsModel>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? code,
      int? vehicle_make_id,
      String? created_at,
      String? updated_at,
      String? deleted_at});
}

/// @nodoc
class _$CarsModelCopyWithImpl<$Res, $Val extends CarsModel>
    implements $CarsModelCopyWith<$Res> {
  _$CarsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? code = freezed,
    Object? vehicle_make_id = freezed,
    Object? created_at = freezed,
    Object? updated_at = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicle_make_id: freezed == vehicle_make_id
          ? _value.vehicle_make_id
          : vehicle_make_id // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as String?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CarsModelCopyWith<$Res> implements $CarsModelCopyWith<$Res> {
  factory _$$_CarsModelCopyWith(
          _$_CarsModel value, $Res Function(_$_CarsModel) then) =
      __$$_CarsModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? code,
      int? vehicle_make_id,
      String? created_at,
      String? updated_at,
      String? deleted_at});
}

/// @nodoc
class __$$_CarsModelCopyWithImpl<$Res>
    extends _$CarsModelCopyWithImpl<$Res, _$_CarsModel>
    implements _$$_CarsModelCopyWith<$Res> {
  __$$_CarsModelCopyWithImpl(
      _$_CarsModel _value, $Res Function(_$_CarsModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? code = freezed,
    Object? vehicle_make_id = freezed,
    Object? created_at = freezed,
    Object? updated_at = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_$_CarsModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicle_make_id: freezed == vehicle_make_id
          ? _value.vehicle_make_id
          : vehicle_make_id // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as String?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CarsModel implements _CarsModel {
  const _$_CarsModel(
      {this.id,
      this.name,
      this.code,
      this.vehicle_make_id,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory _$_CarsModel.fromJson(Map<String, dynamic> json) =>
      _$$_CarsModelFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? code;
  @override
  final int? vehicle_make_id;
  @override
  final String? created_at;
  @override
  final String? updated_at;
  @override
  final String? deleted_at;

  @override
  String toString() {
    return 'CarsModel(id: $id, name: $name, code: $code, vehicle_make_id: $vehicle_make_id, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CarsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.vehicle_make_id, vehicle_make_id) ||
                other.vehicle_make_id == vehicle_make_id) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, code, vehicle_make_id,
      created_at, updated_at, deleted_at);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CarsModelCopyWith<_$_CarsModel> get copyWith =>
      __$$_CarsModelCopyWithImpl<_$_CarsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CarsModelToJson(
      this,
    );
  }
}

abstract class _CarsModel implements CarsModel {
  const factory _CarsModel(
      {final int? id,
      final String? name,
      final String? code,
      final int? vehicle_make_id,
      final String? created_at,
      final String? updated_at,
      final String? deleted_at}) = _$_CarsModel;

  factory _CarsModel.fromJson(Map<String, dynamic> json) =
      _$_CarsModel.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get code;
  @override
  int? get vehicle_make_id;
  @override
  String? get created_at;
  @override
  String? get updated_at;
  @override
  String? get deleted_at;
  @override
  @JsonKey(ignore: true)
  _$$_CarsModelCopyWith<_$_CarsModel> get copyWith =>
      throw _privateConstructorUsedError;
}
