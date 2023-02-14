// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gendermodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GenderModel _$GenderModelFromJson(Map<String, dynamic> json) {
  return _GenderModel.fromJson(json);
}

/// @nodoc
mixin _$GenderModel {
  int? get id => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get created_at => throw _privateConstructorUsedError;
  String? get updated_at => throw _privateConstructorUsedError;
  String? get deleted_at => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GenderModelCopyWith<GenderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenderModelCopyWith<$Res> {
  factory $GenderModelCopyWith(
          GenderModel value, $Res Function(GenderModel) then) =
      _$GenderModelCopyWithImpl<$Res, GenderModel>;
  @useResult
  $Res call(
      {int? id,
      String? code,
      String? name,
      String? created_at,
      String? updated_at,
      String? deleted_at});
}

/// @nodoc
class _$GenderModelCopyWithImpl<$Res, $Val extends GenderModel>
    implements $GenderModelCopyWith<$Res> {
  _$GenderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? code = freezed,
    Object? name = freezed,
    Object? created_at = freezed,
    Object? updated_at = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$_GenderModelCopyWith<$Res>
    implements $GenderModelCopyWith<$Res> {
  factory _$$_GenderModelCopyWith(
          _$_GenderModel value, $Res Function(_$_GenderModel) then) =
      __$$_GenderModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? code,
      String? name,
      String? created_at,
      String? updated_at,
      String? deleted_at});
}

/// @nodoc
class __$$_GenderModelCopyWithImpl<$Res>
    extends _$GenderModelCopyWithImpl<$Res, _$_GenderModel>
    implements _$$_GenderModelCopyWith<$Res> {
  __$$_GenderModelCopyWithImpl(
      _$_GenderModel _value, $Res Function(_$_GenderModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? code = freezed,
    Object? name = freezed,
    Object? created_at = freezed,
    Object? updated_at = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_$_GenderModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$_GenderModel implements _GenderModel {
  const _$_GenderModel(
      {this.id,
      this.code,
      this.name,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory _$_GenderModel.fromJson(Map<String, dynamic> json) =>
      _$$_GenderModelFromJson(json);

  @override
  final int? id;
  @override
  final String? code;
  @override
  final String? name;
  @override
  final String? created_at;
  @override
  final String? updated_at;
  @override
  final String? deleted_at;

  @override
  String toString() {
    return 'GenderModel(id: $id, code: $code, name: $name, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GenderModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, code, name, created_at, updated_at, deleted_at);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GenderModelCopyWith<_$_GenderModel> get copyWith =>
      __$$_GenderModelCopyWithImpl<_$_GenderModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GenderModelToJson(
      this,
    );
  }
}

abstract class _GenderModel implements GenderModel {
  const factory _GenderModel(
      {final int? id,
      final String? code,
      final String? name,
      final String? created_at,
      final String? updated_at,
      final String? deleted_at}) = _$_GenderModel;

  factory _GenderModel.fromJson(Map<String, dynamic> json) =
      _$_GenderModel.fromJson;

  @override
  int? get id;
  @override
  String? get code;
  @override
  String? get name;
  @override
  String? get created_at;
  @override
  String? get updated_at;
  @override
  String? get deleted_at;
  @override
  @JsonKey(ignore: true)
  _$$_GenderModelCopyWith<_$_GenderModel> get copyWith =>
      throw _privateConstructorUsedError;
}
