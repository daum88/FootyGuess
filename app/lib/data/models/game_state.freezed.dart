// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  String get mode => throw _privateConstructorUsedError;
  String get day => throw _privateConstructorUsedError;
  List<String> get attempts => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<String> get hintsUsed => throw _privateConstructorUsedError;
  Map<String, dynamic>? get gameData => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {String mode,
      String day,
      List<String> attempts,
      int points,
      bool isCompleted,
      DateTime startedAt,
      DateTime? completedAt,
      List<String> hintsUsed,
      Map<String, dynamic>? gameData});
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? day = null,
    Object? attempts = null,
    Object? points = null,
    Object? isCompleted = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? hintsUsed = null,
    Object? gameData = freezed,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hintsUsed: null == hintsUsed
          ? _value.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      gameData: freezed == gameData
          ? _value.gameData
          : gameData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String mode,
      String day,
      List<String> attempts,
      int points,
      bool isCompleted,
      DateTime startedAt,
      DateTime? completedAt,
      List<String> hintsUsed,
      Map<String, dynamic>? gameData});
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? day = null,
    Object? attempts = null,
    Object? points = null,
    Object? isCompleted = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? hintsUsed = null,
    Object? gameData = freezed,
  }) {
    return _then(_$GameStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      attempts: null == attempts
          ? _value._attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hintsUsed: null == hintsUsed
          ? _value._hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      gameData: freezed == gameData
          ? _value._gameData
          : gameData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl implements _GameState {
  const _$GameStateImpl(
      {required this.mode,
      required this.day,
      required final List<String> attempts,
      required this.points,
      required this.isCompleted,
      required this.startedAt,
      this.completedAt,
      final List<String> hintsUsed = const [],
      final Map<String, dynamic>? gameData})
      : _attempts = attempts,
        _hintsUsed = hintsUsed,
        _gameData = gameData;

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  @override
  final String mode;
  @override
  final String day;
  final List<String> _attempts;
  @override
  List<String> get attempts {
    if (_attempts is EqualUnmodifiableListView) return _attempts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attempts);
  }

  @override
  final int points;
  @override
  final bool isCompleted;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  final List<String> _hintsUsed;
  @override
  @JsonKey()
  List<String> get hintsUsed {
    if (_hintsUsed is EqualUnmodifiableListView) return _hintsUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hintsUsed);
  }

  final Map<String, dynamic>? _gameData;
  @override
  Map<String, dynamic>? get gameData {
    final value = _gameData;
    if (value == null) return null;
    if (_gameData is EqualUnmodifiableMapView) return _gameData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GameState(mode: $mode, day: $day, attempts: $attempts, points: $points, isCompleted: $isCompleted, startedAt: $startedAt, completedAt: $completedAt, hintsUsed: $hintsUsed, gameData: $gameData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality().equals(other._attempts, _attempts) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality()
                .equals(other._hintsUsed, _hintsUsed) &&
            const DeepCollectionEquality().equals(other._gameData, _gameData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      day,
      const DeepCollectionEquality().hash(_attempts),
      points,
      isCompleted,
      startedAt,
      completedAt,
      const DeepCollectionEquality().hash(_hintsUsed),
      const DeepCollectionEquality().hash(_gameData));

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(
      this,
    );
  }
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {required final String mode,
      required final String day,
      required final List<String> attempts,
      required final int points,
      required final bool isCompleted,
      required final DateTime startedAt,
      final DateTime? completedAt,
      final List<String> hintsUsed,
      final Map<String, dynamic>? gameData}) = _$GameStateImpl;

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  String get mode;
  @override
  String get day;
  @override
  List<String> get attempts;
  @override
  int get points;
  @override
  bool get isCompleted;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  List<String> get hintsUsed;
  @override
  Map<String, dynamic>? get gameData;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get uid => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get streakCount => throw _privateConstructorUsedError;
  Map<String, dynamic> get preferences => throw _privateConstructorUsedError;
  String? get favoriteClub => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  Map<String, int> get gameStats => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String? photoURL,
      DateTime createdAt,
      int streakCount,
      Map<String, dynamic> preferences,
      String? favoriteClub,
      int totalPoints,
      Map<String, int> gameStats});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? photoURL = freezed,
    Object? createdAt = null,
    Object? streakCount = null,
    Object? preferences = null,
    Object? favoriteClub = freezed,
    Object? totalPoints = null,
    Object? gameStats = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      streakCount: null == streakCount
          ? _value.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      favoriteClub: freezed == favoriteClub
          ? _value.favoriteClub
          : favoriteClub // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      gameStats: null == gameStats
          ? _value.gameStats
          : gameStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String? photoURL,
      DateTime createdAt,
      int streakCount,
      Map<String, dynamic> preferences,
      String? favoriteClub,
      int totalPoints,
      Map<String, int> gameStats});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? photoURL = freezed,
    Object? createdAt = null,
    Object? streakCount = null,
    Object? preferences = null,
    Object? favoriteClub = freezed,
    Object? totalPoints = null,
    Object? gameStats = null,
  }) {
    return _then(_$UserProfileImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      streakCount: null == streakCount
          ? _value.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      favoriteClub: freezed == favoriteClub
          ? _value.favoriteClub
          : favoriteClub // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      gameStats: null == gameStats
          ? _value._gameStats
          : gameStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.uid,
      required this.displayName,
      this.photoURL,
      required this.createdAt,
      this.streakCount = 0,
      final Map<String, dynamic> preferences = const {},
      this.favoriteClub,
      this.totalPoints = 0,
      final Map<String, int> gameStats = const {}})
      : _preferences = preferences,
        _gameStats = gameStats;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String? photoURL;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int streakCount;
  final Map<String, dynamic> _preferences;
  @override
  @JsonKey()
  Map<String, dynamic> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  @override
  final String? favoriteClub;
  @override
  @JsonKey()
  final int totalPoints;
  final Map<String, int> _gameStats;
  @override
  @JsonKey()
  Map<String, int> get gameStats {
    if (_gameStats is EqualUnmodifiableMapView) return _gameStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_gameStats);
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, displayName: $displayName, photoURL: $photoURL, createdAt: $createdAt, streakCount: $streakCount, preferences: $preferences, favoriteClub: $favoriteClub, totalPoints: $totalPoints, gameStats: $gameStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            (identical(other.favoriteClub, favoriteClub) ||
                other.favoriteClub == favoriteClub) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            const DeepCollectionEquality()
                .equals(other._gameStats, _gameStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      displayName,
      photoURL,
      createdAt,
      streakCount,
      const DeepCollectionEquality().hash(_preferences),
      favoriteClub,
      totalPoints,
      const DeepCollectionEquality().hash(_gameStats));

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String uid,
      required final String displayName,
      final String? photoURL,
      required final DateTime createdAt,
      final int streakCount,
      final Map<String, dynamic> preferences,
      final String? favoriteClub,
      final int totalPoints,
      final Map<String, int> gameStats}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get uid;
  @override
  String get displayName;
  @override
  String? get photoURL;
  @override
  DateTime get createdAt;
  @override
  int get streakCount;
  @override
  Map<String, dynamic> get preferences;
  @override
  String? get favoriteClub;
  @override
  int get totalPoints;
  @override
  Map<String, int> get gameStats;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScoreEntry _$ScoreEntryFromJson(Map<String, dynamic> json) {
  return _ScoreEntry.fromJson(json);
}

/// @nodoc
mixin _$ScoreEntry {
  String get uid => throw _privateConstructorUsedError;
  String get mode => throw _privateConstructorUsedError;
  String get day => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get timeMs => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get receipt => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  /// Serializes this ScoreEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoreEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreEntryCopyWith<ScoreEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreEntryCopyWith<$Res> {
  factory $ScoreEntryCopyWith(
          ScoreEntry value, $Res Function(ScoreEntry) then) =
      _$ScoreEntryCopyWithImpl<$Res, ScoreEntry>;
  @useResult
  $Res call(
      {String uid,
      String mode,
      String day,
      int attempts,
      int points,
      int timeMs,
      DateTime createdAt,
      String receipt,
      String version});
}

/// @nodoc
class _$ScoreEntryCopyWithImpl<$Res, $Val extends ScoreEntry>
    implements $ScoreEntryCopyWith<$Res> {
  _$ScoreEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? mode = null,
    Object? day = null,
    Object? attempts = null,
    Object? points = null,
    Object? timeMs = null,
    Object? createdAt = null,
    Object? receipt = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      timeMs: null == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      receipt: null == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScoreEntryImplCopyWith<$Res>
    implements $ScoreEntryCopyWith<$Res> {
  factory _$$ScoreEntryImplCopyWith(
          _$ScoreEntryImpl value, $Res Function(_$ScoreEntryImpl) then) =
      __$$ScoreEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String mode,
      String day,
      int attempts,
      int points,
      int timeMs,
      DateTime createdAt,
      String receipt,
      String version});
}

/// @nodoc
class __$$ScoreEntryImplCopyWithImpl<$Res>
    extends _$ScoreEntryCopyWithImpl<$Res, _$ScoreEntryImpl>
    implements _$$ScoreEntryImplCopyWith<$Res> {
  __$$ScoreEntryImplCopyWithImpl(
      _$ScoreEntryImpl _value, $Res Function(_$ScoreEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScoreEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? mode = null,
    Object? day = null,
    Object? attempts = null,
    Object? points = null,
    Object? timeMs = null,
    Object? createdAt = null,
    Object? receipt = null,
    Object? version = null,
  }) {
    return _then(_$ScoreEntryImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      timeMs: null == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      receipt: null == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreEntryImpl implements _ScoreEntry {
  const _$ScoreEntryImpl(
      {required this.uid,
      required this.mode,
      required this.day,
      required this.attempts,
      required this.points,
      required this.timeMs,
      required this.createdAt,
      required this.receipt,
      required this.version});

  factory _$ScoreEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreEntryImplFromJson(json);

  @override
  final String uid;
  @override
  final String mode;
  @override
  final String day;
  @override
  final int attempts;
  @override
  final int points;
  @override
  final int timeMs;
  @override
  final DateTime createdAt;
  @override
  final String receipt;
  @override
  final String version;

  @override
  String toString() {
    return 'ScoreEntry(uid: $uid, mode: $mode, day: $day, attempts: $attempts, points: $points, timeMs: $timeMs, createdAt: $createdAt, receipt: $receipt, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreEntryImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.timeMs, timeMs) || other.timeMs == timeMs) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.receipt, receipt) || other.receipt == receipt) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, mode, day, attempts, points,
      timeMs, createdAt, receipt, version);

  /// Create a copy of ScoreEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreEntryImplCopyWith<_$ScoreEntryImpl> get copyWith =>
      __$$ScoreEntryImplCopyWithImpl<_$ScoreEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreEntryImplToJson(
      this,
    );
  }
}

abstract class _ScoreEntry implements ScoreEntry {
  const factory _ScoreEntry(
      {required final String uid,
      required final String mode,
      required final String day,
      required final int attempts,
      required final int points,
      required final int timeMs,
      required final DateTime createdAt,
      required final String receipt,
      required final String version}) = _$ScoreEntryImpl;

  factory _ScoreEntry.fromJson(Map<String, dynamic> json) =
      _$ScoreEntryImpl.fromJson;

  @override
  String get uid;
  @override
  String get mode;
  @override
  String get day;
  @override
  int get attempts;
  @override
  int get points;
  @override
  int get timeMs;
  @override
  DateTime get createdAt;
  @override
  String get receipt;
  @override
  String get version;

  /// Create a copy of ScoreEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreEntryImplCopyWith<_$ScoreEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) {
  return _LeaderboardEntry.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntry {
  String get uid => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryCopyWith<$Res> {
  factory $LeaderboardEntryCopyWith(
          LeaderboardEntry value, $Res Function(LeaderboardEntry) then) =
      _$LeaderboardEntryCopyWithImpl<$Res, LeaderboardEntry>;
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String? photoURL,
      int points,
      int rank,
      DateTime createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res, $Val extends LeaderboardEntry>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? photoURL = freezed,
    Object? points = null,
    Object? rank = null,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryImplCopyWith<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  factory _$$LeaderboardEntryImplCopyWith(_$LeaderboardEntryImpl value,
          $Res Function(_$LeaderboardEntryImpl) then) =
      __$$LeaderboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String? photoURL,
      int points,
      int rank,
      DateTime createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$LeaderboardEntryImplCopyWithImpl<$Res>
    extends _$LeaderboardEntryCopyWithImpl<$Res, _$LeaderboardEntryImpl>
    implements _$$LeaderboardEntryImplCopyWith<$Res> {
  __$$LeaderboardEntryImplCopyWithImpl(_$LeaderboardEntryImpl _value,
      $Res Function(_$LeaderboardEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? photoURL = freezed,
    Object? points = null,
    Object? rank = null,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_$LeaderboardEntryImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntryImpl implements _LeaderboardEntry {
  const _$LeaderboardEntryImpl(
      {required this.uid,
      required this.displayName,
      this.photoURL,
      required this.points,
      required this.rank,
      required this.createdAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$LeaderboardEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryImplFromJson(json);

  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String? photoURL;
  @override
  final int points;
  @override
  final int rank;
  @override
  final DateTime createdAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LeaderboardEntry(uid: $uid, displayName: $displayName, photoURL: $photoURL, points: $points, rank: $rank, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, displayName, photoURL,
      points, rank, createdAt, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      __$$LeaderboardEntryImplCopyWithImpl<_$LeaderboardEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryImplToJson(
      this,
    );
  }
}

abstract class _LeaderboardEntry implements LeaderboardEntry {
  const factory _LeaderboardEntry(
      {required final String uid,
      required final String displayName,
      final String? photoURL,
      required final int points,
      required final int rank,
      required final DateTime createdAt,
      final Map<String, dynamic>? metadata}) = _$LeaderboardEntryImpl;

  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryImpl.fromJson;

  @override
  String get uid;
  @override
  String get displayName;
  @override
  String? get photoURL;
  @override
  int get points;
  @override
  int get rank;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyPuzzle _$DailyPuzzleFromJson(Map<String, dynamic> json) {
  return _DailyPuzzle.fromJson(json);
}

/// @nodoc
mixin _$DailyPuzzle {
  String get mode => throw _privateConstructorUsedError;
  String get day => throw _privateConstructorUsedError;
  String get puzzleId => throw _privateConstructorUsedError;
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;
  String get metaHash => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DailyPuzzle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPuzzle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPuzzleCopyWith<DailyPuzzle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPuzzleCopyWith<$Res> {
  factory $DailyPuzzleCopyWith(
          DailyPuzzle value, $Res Function(DailyPuzzle) then) =
      _$DailyPuzzleCopyWithImpl<$Res, DailyPuzzle>;
  @useResult
  $Res call(
      {String mode,
      String day,
      String puzzleId,
      Map<String, dynamic> payload,
      String metaHash,
      String version,
      DateTime createdAt});
}

/// @nodoc
class _$DailyPuzzleCopyWithImpl<$Res, $Val extends DailyPuzzle>
    implements $DailyPuzzleCopyWith<$Res> {
  _$DailyPuzzleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPuzzle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? day = null,
    Object? puzzleId = null,
    Object? payload = null,
    Object? metaHash = null,
    Object? version = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      puzzleId: null == puzzleId
          ? _value.puzzleId
          : puzzleId // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      metaHash: null == metaHash
          ? _value.metaHash
          : metaHash // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPuzzleImplCopyWith<$Res>
    implements $DailyPuzzleCopyWith<$Res> {
  factory _$$DailyPuzzleImplCopyWith(
          _$DailyPuzzleImpl value, $Res Function(_$DailyPuzzleImpl) then) =
      __$$DailyPuzzleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String mode,
      String day,
      String puzzleId,
      Map<String, dynamic> payload,
      String metaHash,
      String version,
      DateTime createdAt});
}

/// @nodoc
class __$$DailyPuzzleImplCopyWithImpl<$Res>
    extends _$DailyPuzzleCopyWithImpl<$Res, _$DailyPuzzleImpl>
    implements _$$DailyPuzzleImplCopyWith<$Res> {
  __$$DailyPuzzleImplCopyWithImpl(
      _$DailyPuzzleImpl _value, $Res Function(_$DailyPuzzleImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPuzzle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? day = null,
    Object? puzzleId = null,
    Object? payload = null,
    Object? metaHash = null,
    Object? version = null,
    Object? createdAt = null,
  }) {
    return _then(_$DailyPuzzleImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      puzzleId: null == puzzleId
          ? _value.puzzleId
          : puzzleId // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      metaHash: null == metaHash
          ? _value.metaHash
          : metaHash // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPuzzleImpl implements _DailyPuzzle {
  const _$DailyPuzzleImpl(
      {required this.mode,
      required this.day,
      required this.puzzleId,
      required final Map<String, dynamic> payload,
      required this.metaHash,
      required this.version,
      required this.createdAt})
      : _payload = payload;

  factory _$DailyPuzzleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPuzzleImplFromJson(json);

  @override
  final String mode;
  @override
  final String day;
  @override
  final String puzzleId;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  final String metaHash;
  @override
  final String version;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'DailyPuzzle(mode: $mode, day: $day, puzzleId: $puzzleId, payload: $payload, metaHash: $metaHash, version: $version, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPuzzleImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.puzzleId, puzzleId) ||
                other.puzzleId == puzzleId) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.metaHash, metaHash) ||
                other.metaHash == metaHash) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      day,
      puzzleId,
      const DeepCollectionEquality().hash(_payload),
      metaHash,
      version,
      createdAt);

  /// Create a copy of DailyPuzzle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPuzzleImplCopyWith<_$DailyPuzzleImpl> get copyWith =>
      __$$DailyPuzzleImplCopyWithImpl<_$DailyPuzzleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPuzzleImplToJson(
      this,
    );
  }
}

abstract class _DailyPuzzle implements DailyPuzzle {
  const factory _DailyPuzzle(
      {required final String mode,
      required final String day,
      required final String puzzleId,
      required final Map<String, dynamic> payload,
      required final String metaHash,
      required final String version,
      required final DateTime createdAt}) = _$DailyPuzzleImpl;

  factory _DailyPuzzle.fromJson(Map<String, dynamic> json) =
      _$DailyPuzzleImpl.fromJson;

  @override
  String get mode;
  @override
  String get day;
  @override
  String get puzzleId;
  @override
  Map<String, dynamic> get payload;
  @override
  String get metaHash;
  @override
  String get version;
  @override
  DateTime get createdAt;

  /// Create a copy of DailyPuzzle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPuzzleImplCopyWith<_$DailyPuzzleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HintData _$HintDataFromJson(Map<String, dynamic> json) {
  return _HintData.fromJson(json);
}

/// @nodoc
mixin _$HintData {
  String get hintType => throw _privateConstructorUsedError;
  int get cost => throw _privateConstructorUsedError;
  String get hintText => throw _privateConstructorUsedError;
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;
  double? get specificityScore => throw _privateConstructorUsedError;

  /// Serializes this HintData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HintData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HintDataCopyWith<HintData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HintDataCopyWith<$Res> {
  factory $HintDataCopyWith(HintData value, $Res Function(HintData) then) =
      _$HintDataCopyWithImpl<$Res, HintData>;
  @useResult
  $Res call(
      {String hintType,
      int cost,
      String hintText,
      Map<String, dynamic> payload,
      double? specificityScore});
}

/// @nodoc
class _$HintDataCopyWithImpl<$Res, $Val extends HintData>
    implements $HintDataCopyWith<$Res> {
  _$HintDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HintData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hintType = null,
    Object? cost = null,
    Object? hintText = null,
    Object? payload = null,
    Object? specificityScore = freezed,
  }) {
    return _then(_value.copyWith(
      hintType: null == hintType
          ? _value.hintType
          : hintType // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as int,
      hintText: null == hintText
          ? _value.hintText
          : hintText // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      specificityScore: freezed == specificityScore
          ? _value.specificityScore
          : specificityScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HintDataImplCopyWith<$Res>
    implements $HintDataCopyWith<$Res> {
  factory _$$HintDataImplCopyWith(
          _$HintDataImpl value, $Res Function(_$HintDataImpl) then) =
      __$$HintDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String hintType,
      int cost,
      String hintText,
      Map<String, dynamic> payload,
      double? specificityScore});
}

/// @nodoc
class __$$HintDataImplCopyWithImpl<$Res>
    extends _$HintDataCopyWithImpl<$Res, _$HintDataImpl>
    implements _$$HintDataImplCopyWith<$Res> {
  __$$HintDataImplCopyWithImpl(
      _$HintDataImpl _value, $Res Function(_$HintDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hintType = null,
    Object? cost = null,
    Object? hintText = null,
    Object? payload = null,
    Object? specificityScore = freezed,
  }) {
    return _then(_$HintDataImpl(
      hintType: null == hintType
          ? _value.hintType
          : hintType // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as int,
      hintText: null == hintText
          ? _value.hintText
          : hintText // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      specificityScore: freezed == specificityScore
          ? _value.specificityScore
          : specificityScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HintDataImpl implements _HintData {
  const _$HintDataImpl(
      {required this.hintType,
      required this.cost,
      required this.hintText,
      required final Map<String, dynamic> payload,
      this.specificityScore})
      : _payload = payload;

  factory _$HintDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HintDataImplFromJson(json);

  @override
  final String hintType;
  @override
  final int cost;
  @override
  final String hintText;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  final double? specificityScore;

  @override
  String toString() {
    return 'HintData(hintType: $hintType, cost: $cost, hintText: $hintText, payload: $payload, specificityScore: $specificityScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HintDataImpl &&
            (identical(other.hintType, hintType) ||
                other.hintType == hintType) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.hintText, hintText) ||
                other.hintText == hintText) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.specificityScore, specificityScore) ||
                other.specificityScore == specificityScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hintType, cost, hintText,
      const DeepCollectionEquality().hash(_payload), specificityScore);

  /// Create a copy of HintData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HintDataImplCopyWith<_$HintDataImpl> get copyWith =>
      __$$HintDataImplCopyWithImpl<_$HintDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HintDataImplToJson(
      this,
    );
  }
}

abstract class _HintData implements HintData {
  const factory _HintData(
      {required final String hintType,
      required final int cost,
      required final String hintText,
      required final Map<String, dynamic> payload,
      final double? specificityScore}) = _$HintDataImpl;

  factory _HintData.fromJson(Map<String, dynamic> json) =
      _$HintDataImpl.fromJson;

  @override
  String get hintType;
  @override
  int get cost;
  @override
  String get hintText;
  @override
  Map<String, dynamic> get payload;
  @override
  double? get specificityScore;

  /// Create a copy of HintData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HintDataImplCopyWith<_$HintDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
