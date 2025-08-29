// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nationality => throw _privateConstructorUsedError;
  DateTime get dateOfBirth => throw _privateConstructorUsedError;
  List<String> get positions => throw _privateConstructorUsedError;
  String get primaryPosition => throw _privateConstructorUsedError;
  List<ClubHistory> get clubs => throw _privateConstructorUsedError;
  List<String> get leagues => throw _privateConstructorUsedError;
  String get teammatesHash => throw _privateConstructorUsedError;
  Map<String, dynamic>? get meta => throw _privateConstructorUsedError;

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call(
      {String id,
      String name,
      String nationality,
      DateTime dateOfBirth,
      List<String> positions,
      String primaryPosition,
      List<ClubHistory> clubs,
      List<String> leagues,
      String teammatesHash,
      Map<String, dynamic>? meta});
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nationality = null,
    Object? dateOfBirth = null,
    Object? positions = null,
    Object? primaryPosition = null,
    Object? clubs = null,
    Object? leagues = null,
    Object? teammatesHash = null,
    Object? meta = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nationality: null == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      positions: null == positions
          ? _value.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      primaryPosition: null == primaryPosition
          ? _value.primaryPosition
          : primaryPosition // ignore: cast_nullable_to_non_nullable
              as String,
      clubs: null == clubs
          ? _value.clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as List<ClubHistory>,
      leagues: null == leagues
          ? _value.leagues
          : leagues // ignore: cast_nullable_to_non_nullable
              as List<String>,
      teammatesHash: null == teammatesHash
          ? _value.teammatesHash
          : teammatesHash // ignore: cast_nullable_to_non_nullable
              as String,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
          _$PlayerImpl value, $Res Function(_$PlayerImpl) then) =
      __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String nationality,
      DateTime dateOfBirth,
      List<String> positions,
      String primaryPosition,
      List<ClubHistory> clubs,
      List<String> leagues,
      String teammatesHash,
      Map<String, dynamic>? meta});
}

/// @nodoc
class __$$PlayerImplCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$PlayerImpl>
    implements _$$PlayerImplCopyWith<$Res> {
  __$$PlayerImplCopyWithImpl(
      _$PlayerImpl _value, $Res Function(_$PlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nationality = null,
    Object? dateOfBirth = null,
    Object? positions = null,
    Object? primaryPosition = null,
    Object? clubs = null,
    Object? leagues = null,
    Object? teammatesHash = null,
    Object? meta = freezed,
  }) {
    return _then(_$PlayerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nationality: null == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      positions: null == positions
          ? _value._positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      primaryPosition: null == primaryPosition
          ? _value.primaryPosition
          : primaryPosition // ignore: cast_nullable_to_non_nullable
              as String,
      clubs: null == clubs
          ? _value._clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as List<ClubHistory>,
      leagues: null == leagues
          ? _value._leagues
          : leagues // ignore: cast_nullable_to_non_nullable
              as List<String>,
      teammatesHash: null == teammatesHash
          ? _value.teammatesHash
          : teammatesHash // ignore: cast_nullable_to_non_nullable
              as String,
      meta: freezed == meta
          ? _value._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl implements _Player {
  const _$PlayerImpl(
      {required this.id,
      required this.name,
      required this.nationality,
      required this.dateOfBirth,
      required final List<String> positions,
      required this.primaryPosition,
      required final List<ClubHistory> clubs,
      required final List<String> leagues,
      required this.teammatesHash,
      final Map<String, dynamic>? meta})
      : _positions = positions,
        _clubs = clubs,
        _leagues = leagues,
        _meta = meta;

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String nationality;
  @override
  final DateTime dateOfBirth;
  final List<String> _positions;
  @override
  List<String> get positions {
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positions);
  }

  @override
  final String primaryPosition;
  final List<ClubHistory> _clubs;
  @override
  List<ClubHistory> get clubs {
    if (_clubs is EqualUnmodifiableListView) return _clubs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clubs);
  }

  final List<String> _leagues;
  @override
  List<String> get leagues {
    if (_leagues is EqualUnmodifiableListView) return _leagues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_leagues);
  }

  @override
  final String teammatesHash;
  final Map<String, dynamic>? _meta;
  @override
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Player(id: $id, name: $name, nationality: $nationality, dateOfBirth: $dateOfBirth, positions: $positions, primaryPosition: $primaryPosition, clubs: $clubs, leagues: $leagues, teammatesHash: $teammatesHash, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            const DeepCollectionEquality()
                .equals(other._positions, _positions) &&
            (identical(other.primaryPosition, primaryPosition) ||
                other.primaryPosition == primaryPosition) &&
            const DeepCollectionEquality().equals(other._clubs, _clubs) &&
            const DeepCollectionEquality().equals(other._leagues, _leagues) &&
            (identical(other.teammatesHash, teammatesHash) ||
                other.teammatesHash == teammatesHash) &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      nationality,
      dateOfBirth,
      const DeepCollectionEquality().hash(_positions),
      primaryPosition,
      const DeepCollectionEquality().hash(_clubs),
      const DeepCollectionEquality().hash(_leagues),
      teammatesHash,
      const DeepCollectionEquality().hash(_meta));

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      __$$PlayerImplCopyWithImpl<_$PlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerImplToJson(
      this,
    );
  }
}

abstract class _Player implements Player {
  const factory _Player(
      {required final String id,
      required final String name,
      required final String nationality,
      required final DateTime dateOfBirth,
      required final List<String> positions,
      required final String primaryPosition,
      required final List<ClubHistory> clubs,
      required final List<String> leagues,
      required final String teammatesHash,
      final Map<String, dynamic>? meta}) = _$PlayerImpl;

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get nationality;
  @override
  DateTime get dateOfBirth;
  @override
  List<String> get positions;
  @override
  String get primaryPosition;
  @override
  List<ClubHistory> get clubs;
  @override
  List<String> get leagues;
  @override
  String get teammatesHash;
  @override
  Map<String, dynamic>? get meta;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClubHistory _$ClubHistoryFromJson(Map<String, dynamic> json) {
  return _ClubHistory.fromJson(json);
}

/// @nodoc
mixin _$ClubHistory {
  String get clubId => throw _privateConstructorUsedError;
  DateTime get from => throw _privateConstructorUsedError;
  DateTime? get to => throw _privateConstructorUsedError;
  bool get isLoan => throw _privateConstructorUsedError;

  /// Serializes this ClubHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubHistoryCopyWith<ClubHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubHistoryCopyWith<$Res> {
  factory $ClubHistoryCopyWith(
          ClubHistory value, $Res Function(ClubHistory) then) =
      _$ClubHistoryCopyWithImpl<$Res, ClubHistory>;
  @useResult
  $Res call({String clubId, DateTime from, DateTime? to, bool isLoan});
}

/// @nodoc
class _$ClubHistoryCopyWithImpl<$Res, $Val extends ClubHistory>
    implements $ClubHistoryCopyWith<$Res> {
  _$ClubHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clubId = null,
    Object? from = null,
    Object? to = freezed,
    Object? isLoan = null,
  }) {
    return _then(_value.copyWith(
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: freezed == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoan: null == isLoan
          ? _value.isLoan
          : isLoan // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubHistoryImplCopyWith<$Res>
    implements $ClubHistoryCopyWith<$Res> {
  factory _$$ClubHistoryImplCopyWith(
          _$ClubHistoryImpl value, $Res Function(_$ClubHistoryImpl) then) =
      __$$ClubHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String clubId, DateTime from, DateTime? to, bool isLoan});
}

/// @nodoc
class __$$ClubHistoryImplCopyWithImpl<$Res>
    extends _$ClubHistoryCopyWithImpl<$Res, _$ClubHistoryImpl>
    implements _$$ClubHistoryImplCopyWith<$Res> {
  __$$ClubHistoryImplCopyWithImpl(
      _$ClubHistoryImpl _value, $Res Function(_$ClubHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClubHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clubId = null,
    Object? from = null,
    Object? to = freezed,
    Object? isLoan = null,
  }) {
    return _then(_$ClubHistoryImpl(
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: freezed == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoan: null == isLoan
          ? _value.isLoan
          : isLoan // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubHistoryImpl implements _ClubHistory {
  const _$ClubHistoryImpl(
      {required this.clubId, required this.from, this.to, this.isLoan = false});

  factory _$ClubHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubHistoryImplFromJson(json);

  @override
  final String clubId;
  @override
  final DateTime from;
  @override
  final DateTime? to;
  @override
  @JsonKey()
  final bool isLoan;

  @override
  String toString() {
    return 'ClubHistory(clubId: $clubId, from: $from, to: $to, isLoan: $isLoan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubHistoryImpl &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.isLoan, isLoan) || other.isLoan == isLoan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, clubId, from, to, isLoan);

  /// Create a copy of ClubHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubHistoryImplCopyWith<_$ClubHistoryImpl> get copyWith =>
      __$$ClubHistoryImplCopyWithImpl<_$ClubHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubHistoryImplToJson(
      this,
    );
  }
}

abstract class _ClubHistory implements ClubHistory {
  const factory _ClubHistory(
      {required final String clubId,
      required final DateTime from,
      final DateTime? to,
      final bool isLoan}) = _$ClubHistoryImpl;

  factory _ClubHistory.fromJson(Map<String, dynamic> json) =
      _$ClubHistoryImpl.fromJson;

  @override
  String get clubId;
  @override
  DateTime get from;
  @override
  DateTime? get to;
  @override
  bool get isLoan;

  /// Create a copy of ClubHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubHistoryImplCopyWith<_$ClubHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Club _$ClubFromJson(Map<String, dynamic> json) {
  return _Club.fromJson(json);
}

/// @nodoc
mixin _$Club {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get leagueId => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  List<String> get rivals => throw _privateConstructorUsedError;

  /// Serializes this Club to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubCopyWith<Club> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubCopyWith<$Res> {
  factory $ClubCopyWith(Club value, $Res Function(Club) then) =
      _$ClubCopyWithImpl<$Res, Club>;
  @useResult
  $Res call(
      {String id,
      String name,
      String leagueId,
      String country,
      List<String> rivals});
}

/// @nodoc
class _$ClubCopyWithImpl<$Res, $Val extends Club>
    implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? leagueId = null,
    Object? country = null,
    Object? rivals = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      rivals: null == rivals
          ? _value.rivals
          : rivals // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubImplCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$$ClubImplCopyWith(
          _$ClubImpl value, $Res Function(_$ClubImpl) then) =
      __$$ClubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String leagueId,
      String country,
      List<String> rivals});
}

/// @nodoc
class __$$ClubImplCopyWithImpl<$Res>
    extends _$ClubCopyWithImpl<$Res, _$ClubImpl>
    implements _$$ClubImplCopyWith<$Res> {
  __$$ClubImplCopyWithImpl(_$ClubImpl _value, $Res Function(_$ClubImpl) _then)
      : super(_value, _then);

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? leagueId = null,
    Object? country = null,
    Object? rivals = null,
  }) {
    return _then(_$ClubImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      rivals: null == rivals
          ? _value._rivals
          : rivals // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubImpl implements _Club {
  const _$ClubImpl(
      {required this.id,
      required this.name,
      required this.leagueId,
      required this.country,
      final List<String> rivals = const []})
      : _rivals = rivals;

  factory _$ClubImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String leagueId;
  @override
  final String country;
  final List<String> _rivals;
  @override
  @JsonKey()
  List<String> get rivals {
    if (_rivals is EqualUnmodifiableListView) return _rivals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rivals);
  }

  @override
  String toString() {
    return 'Club(id: $id, name: $name, leagueId: $leagueId, country: $country, rivals: $rivals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.country, country) || other.country == country) &&
            const DeepCollectionEquality().equals(other._rivals, _rivals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, leagueId, country,
      const DeepCollectionEquality().hash(_rivals));

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith =>
      __$$ClubImplCopyWithImpl<_$ClubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubImplToJson(
      this,
    );
  }
}

abstract class _Club implements Club {
  const factory _Club(
      {required final String id,
      required final String name,
      required final String leagueId,
      required final String country,
      final List<String> rivals}) = _$ClubImpl;

  factory _Club.fromJson(Map<String, dynamic> json) = _$ClubImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get leagueId;
  @override
  String get country;
  @override
  List<String> get rivals;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get competition => throw _privateConstructorUsedError;
  String get homeId => throw _privateConstructorUsedError;
  String get awayId => throw _privateConstructorUsedError;
  List<MatchEvent> get events => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String competition,
      String homeId,
      String awayId,
      List<MatchEvent> events});
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? competition = null,
    Object? homeId = null,
    Object? awayId = null,
    Object? events = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as String,
      homeId: null == homeId
          ? _value.homeId
          : homeId // ignore: cast_nullable_to_non_nullable
              as String,
      awayId: null == awayId
          ? _value.awayId
          : awayId // ignore: cast_nullable_to_non_nullable
              as String,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<MatchEvent>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String competition,
      String homeId,
      String awayId,
      List<MatchEvent> events});
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? competition = null,
    Object? homeId = null,
    Object? awayId = null,
    Object? events = null,
  }) {
    return _then(_$MatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as String,
      homeId: null == homeId
          ? _value.homeId
          : homeId // ignore: cast_nullable_to_non_nullable
              as String,
      awayId: null == awayId
          ? _value.awayId
          : awayId // ignore: cast_nullable_to_non_nullable
              as String,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<MatchEvent>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl(
      {required this.id,
      required this.date,
      required this.competition,
      required this.homeId,
      required this.awayId,
      final List<MatchEvent> events = const []})
      : _events = events;

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String competition;
  @override
  final String homeId;
  @override
  final String awayId;
  final List<MatchEvent> _events;
  @override
  @JsonKey()
  List<MatchEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  String toString() {
    return 'Match(id: $id, date: $date, competition: $competition, homeId: $homeId, awayId: $awayId, events: $events)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.homeId, homeId) || other.homeId == homeId) &&
            (identical(other.awayId, awayId) || other.awayId == awayId) &&
            const DeepCollectionEquality().equals(other._events, _events));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, competition, homeId,
      awayId, const DeepCollectionEquality().hash(_events));

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  const factory _Match(
      {required final String id,
      required final DateTime date,
      required final String competition,
      required final String homeId,
      required final String awayId,
      final List<MatchEvent> events}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get competition;
  @override
  String get homeId;
  @override
  String get awayId;
  @override
  List<MatchEvent> get events;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchEvent _$MatchEventFromJson(Map<String, dynamic> json) {
  return _MatchEvent.fromJson(json);
}

/// @nodoc
mixin _$MatchEvent {
  int get minute => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic>? get details => throw _privateConstructorUsedError;

  /// Serializes this MatchEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchEventCopyWith<MatchEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchEventCopyWith<$Res> {
  factory $MatchEventCopyWith(
          MatchEvent value, $Res Function(MatchEvent) then) =
      _$MatchEventCopyWithImpl<$Res, MatchEvent>;
  @useResult
  $Res call(
      {int minute,
      String playerId,
      String type,
      Map<String, dynamic>? details});
}

/// @nodoc
class _$MatchEventCopyWithImpl<$Res, $Val extends MatchEvent>
    implements $MatchEventCopyWith<$Res> {
  _$MatchEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minute = null,
    Object? playerId = null,
    Object? type = null,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchEventImplCopyWith<$Res>
    implements $MatchEventCopyWith<$Res> {
  factory _$$MatchEventImplCopyWith(
          _$MatchEventImpl value, $Res Function(_$MatchEventImpl) then) =
      __$$MatchEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int minute,
      String playerId,
      String type,
      Map<String, dynamic>? details});
}

/// @nodoc
class __$$MatchEventImplCopyWithImpl<$Res>
    extends _$MatchEventCopyWithImpl<$Res, _$MatchEventImpl>
    implements _$$MatchEventImplCopyWith<$Res> {
  __$$MatchEventImplCopyWithImpl(
      _$MatchEventImpl _value, $Res Function(_$MatchEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minute = null,
    Object? playerId = null,
    Object? type = null,
    Object? details = freezed,
  }) {
    return _then(_$MatchEventImpl(
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchEventImpl implements _MatchEvent {
  const _$MatchEventImpl(
      {required this.minute,
      required this.playerId,
      required this.type,
      final Map<String, dynamic>? details})
      : _details = details;

  factory _$MatchEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchEventImplFromJson(json);

  @override
  final int minute;
  @override
  final String playerId;
  @override
  final String type;
  final Map<String, dynamic>? _details;
  @override
  Map<String, dynamic>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MatchEvent(minute: $minute, playerId: $playerId, type: $type, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchEventImpl &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, minute, playerId, type,
      const DeepCollectionEquality().hash(_details));

  /// Create a copy of MatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchEventImplCopyWith<_$MatchEventImpl> get copyWith =>
      __$$MatchEventImplCopyWithImpl<_$MatchEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchEventImplToJson(
      this,
    );
  }
}

abstract class _MatchEvent implements MatchEvent {
  const factory _MatchEvent(
      {required final int minute,
      required final String playerId,
      required final String type,
      final Map<String, dynamic>? details}) = _$MatchEventImpl;

  factory _MatchEvent.fromJson(Map<String, dynamic> json) =
      _$MatchEventImpl.fromJson;

  @override
  int get minute;
  @override
  String get playerId;
  @override
  String get type;
  @override
  Map<String, dynamic>? get details;

  /// Create a copy of MatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchEventImplCopyWith<_$MatchEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
