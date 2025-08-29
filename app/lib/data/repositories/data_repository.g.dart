// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dataRepositoryHash() => r'c8b90fe18a9c5fd443243d0ab48005f7975cca93';

/// See also [dataRepository].
@ProviderFor(dataRepository)
final dataRepositoryProvider = Provider<DataRepository>.internal(
  dataRepository,
  name: r'dataRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dataRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DataRepositoryRef = ProviderRef<DataRepository>;
String _$allPlayersHash() => r'2364dc960e7d326458350452fad3ef162655b46c';

/// See also [allPlayers].
@ProviderFor(allPlayers)
final allPlayersProvider = AutoDisposeFutureProvider<List<Player>>.internal(
  allPlayers,
  name: r'allPlayersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allPlayersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllPlayersRef = AutoDisposeFutureProviderRef<List<Player>>;
String _$allClubsHash() => r'7bac519541ae6c1d016199f8f58386c86d085ef8';

/// See also [allClubs].
@ProviderFor(allClubs)
final allClubsProvider = AutoDisposeFutureProvider<List<Club>>.internal(
  allClubs,
  name: r'allClubsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allClubsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllClubsRef = AutoDisposeFutureProviderRef<List<Club>>;
String _$playerByIdHash() => r'05863bfe52f8625ddf2c78ccfb466391c6b1a2c7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [playerById].
@ProviderFor(playerById)
const playerByIdProvider = PlayerByIdFamily();

/// See also [playerById].
class PlayerByIdFamily extends Family<AsyncValue<Player?>> {
  /// See also [playerById].
  const PlayerByIdFamily();

  /// See also [playerById].
  PlayerByIdProvider call(
    String id,
  ) {
    return PlayerByIdProvider(
      id,
    );
  }

  @override
  PlayerByIdProvider getProviderOverride(
    covariant PlayerByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playerByIdProvider';
}

/// See also [playerById].
class PlayerByIdProvider extends AutoDisposeFutureProvider<Player?> {
  /// See also [playerById].
  PlayerByIdProvider(
    String id,
  ) : this._internal(
          (ref) => playerById(
            ref as PlayerByIdRef,
            id,
          ),
          from: playerByIdProvider,
          name: r'playerByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playerByIdHash,
          dependencies: PlayerByIdFamily._dependencies,
          allTransitiveDependencies:
              PlayerByIdFamily._allTransitiveDependencies,
          id: id,
        );

  PlayerByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Player?> Function(PlayerByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerByIdProvider._internal(
        (ref) => create(ref as PlayerByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Player?> createElement() {
    return _PlayerByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlayerByIdRef on AutoDisposeFutureProviderRef<Player?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PlayerByIdProviderElement
    extends AutoDisposeFutureProviderElement<Player?> with PlayerByIdRef {
  _PlayerByIdProviderElement(super.provider);

  @override
  String get id => (origin as PlayerByIdProvider).id;
}

String _$clubByIdHash() => r'c3cee5b209dc3c56a49f596bda324878e659d873';

/// See also [clubById].
@ProviderFor(clubById)
const clubByIdProvider = ClubByIdFamily();

/// See also [clubById].
class ClubByIdFamily extends Family<AsyncValue<Club?>> {
  /// See also [clubById].
  const ClubByIdFamily();

  /// See also [clubById].
  ClubByIdProvider call(
    String id,
  ) {
    return ClubByIdProvider(
      id,
    );
  }

  @override
  ClubByIdProvider getProviderOverride(
    covariant ClubByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'clubByIdProvider';
}

/// See also [clubById].
class ClubByIdProvider extends AutoDisposeFutureProvider<Club?> {
  /// See also [clubById].
  ClubByIdProvider(
    String id,
  ) : this._internal(
          (ref) => clubById(
            ref as ClubByIdRef,
            id,
          ),
          from: clubByIdProvider,
          name: r'clubByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubByIdHash,
          dependencies: ClubByIdFamily._dependencies,
          allTransitiveDependencies: ClubByIdFamily._allTransitiveDependencies,
          id: id,
        );

  ClubByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Club?> Function(ClubByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClubByIdProvider._internal(
        (ref) => create(ref as ClubByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Club?> createElement() {
    return _ClubByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubByIdRef on AutoDisposeFutureProviderRef<Club?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ClubByIdProviderElement extends AutoDisposeFutureProviderElement<Club?>
    with ClubByIdRef {
  _ClubByIdProviderElement(super.provider);

  @override
  String get id => (origin as ClubByIdProvider).id;
}

String _$careerStatsPlayersHash() =>
    r'bee2da800b0f6d2a71aa19dc016ac011a8a757a0';

/// See also [careerStatsPlayers].
@ProviderFor(careerStatsPlayers)
final careerStatsPlayersProvider =
    AutoDisposeFutureProvider<List<Player>>.internal(
  careerStatsPlayers,
  name: r'careerStatsPlayersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$careerStatsPlayersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CareerStatsPlayersRef = AutoDisposeFutureProviderRef<List<Player>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
