// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nationality: json['nationality'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      positions:
          (json['positions'] as List<dynamic>).map((e) => e as String).toList(),
      primaryPosition: json['primaryPosition'] as String,
      clubs: (json['clubs'] as List<dynamic>)
          .map((e) => ClubHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      leagues:
          (json['leagues'] as List<dynamic>).map((e) => e as String).toList(),
      teammatesHash: json['teammatesHash'] as String,
      meta: json['meta'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nationality': instance.nationality,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'positions': instance.positions,
      'primaryPosition': instance.primaryPosition,
      'clubs': instance.clubs,
      'leagues': instance.leagues,
      'teammatesHash': instance.teammatesHash,
      'meta': instance.meta,
    };

_$ClubHistoryImpl _$$ClubHistoryImplFromJson(Map<String, dynamic> json) =>
    _$ClubHistoryImpl(
      clubId: json['clubId'] as String,
      from: DateTime.parse(json['from'] as String),
      to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
      isLoan: json['isLoan'] as bool? ?? false,
    );

Map<String, dynamic> _$$ClubHistoryImplToJson(_$ClubHistoryImpl instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'from': instance.from.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'isLoan': instance.isLoan,
    };

_$ClubImpl _$$ClubImplFromJson(Map<String, dynamic> json) => _$ClubImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      leagueId: json['leagueId'] as String,
      country: json['country'] as String,
      rivals: (json['rivals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ClubImplToJson(_$ClubImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'leagueId': instance.leagueId,
      'country': instance.country,
      'rivals': instance.rivals,
    };

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      competition: json['competition'] as String,
      homeId: json['homeId'] as String,
      awayId: json['awayId'] as String,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => MatchEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'competition': instance.competition,
      'homeId': instance.homeId,
      'awayId': instance.awayId,
      'events': instance.events,
    };

_$MatchEventImpl _$$MatchEventImplFromJson(Map<String, dynamic> json) =>
    _$MatchEventImpl(
      minute: (json['minute'] as num).toInt(),
      playerId: json['playerId'] as String,
      type: json['type'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MatchEventImplToJson(_$MatchEventImpl instance) =>
    <String, dynamic>{
      'minute': instance.minute,
      'playerId': instance.playerId,
      'type': instance.type,
      'details': instance.details,
    };
