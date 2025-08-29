// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      mode: json['mode'] as String,
      day: json['day'] as String,
      attempts:
          (json['attempts'] as List<dynamic>).map((e) => e as String).toList(),
      points: (json['points'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      hintsUsed: (json['hintsUsed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      gameData: json['gameData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'day': instance.day,
      'attempts': instance.attempts,
      'points': instance.points,
      'isCompleted': instance.isCompleted,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'hintsUsed': instance.hintsUsed,
      'gameData': instance.gameData,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
      favoriteClub: json['favoriteClub'] as String?,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      gameStats: (json['gameStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'createdAt': instance.createdAt.toIso8601String(),
      'streakCount': instance.streakCount,
      'preferences': instance.preferences,
      'favoriteClub': instance.favoriteClub,
      'totalPoints': instance.totalPoints,
      'gameStats': instance.gameStats,
    };

_$ScoreEntryImpl _$$ScoreEntryImplFromJson(Map<String, dynamic> json) =>
    _$ScoreEntryImpl(
      uid: json['uid'] as String,
      mode: json['mode'] as String,
      day: json['day'] as String,
      attempts: (json['attempts'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      timeMs: (json['timeMs'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      receipt: json['receipt'] as String,
      version: json['version'] as String,
    );

Map<String, dynamic> _$$ScoreEntryImplToJson(_$ScoreEntryImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'mode': instance.mode,
      'day': instance.day,
      'attempts': instance.attempts,
      'points': instance.points,
      'timeMs': instance.timeMs,
      'createdAt': instance.createdAt.toIso8601String(),
      'receipt': instance.receipt,
      'version': instance.version,
    };

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardEntryImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      points: (json['points'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
        _$LeaderboardEntryImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'points': instance.points,
      'rank': instance.rank,
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };

_$DailyPuzzleImpl _$$DailyPuzzleImplFromJson(Map<String, dynamic> json) =>
    _$DailyPuzzleImpl(
      mode: json['mode'] as String,
      day: json['day'] as String,
      puzzleId: json['puzzleId'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      metaHash: json['metaHash'] as String,
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$DailyPuzzleImplToJson(_$DailyPuzzleImpl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'day': instance.day,
      'puzzleId': instance.puzzleId,
      'payload': instance.payload,
      'metaHash': instance.metaHash,
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$HintDataImpl _$$HintDataImplFromJson(Map<String, dynamic> json) =>
    _$HintDataImpl(
      hintType: json['hintType'] as String,
      cost: (json['cost'] as num).toInt(),
      hintText: json['hintText'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      specificityScore: (json['specificityScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$HintDataImplToJson(_$HintDataImpl instance) =>
    <String, dynamic>{
      'hintType': instance.hintType,
      'cost': instance.cost,
      'hintText': instance.hintText,
      'payload': instance.payload,
      'specificityScore': instance.specificityScore,
    };
