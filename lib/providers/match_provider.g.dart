// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$matchRepositoryHash() => r'7f0e70c4b048b15ba8cc0dcb256813592a98461a';

/// See also [matchRepository].
@ProviderFor(matchRepository)
final matchRepositoryProvider = AutoDisposeProvider<MatchRepository>.internal(
  matchRepository,
  name: r'matchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MatchRepositoryRef = AutoDisposeProviderRef<MatchRepository>;
String _$matchStreamHash() => r'995816154f5d885324f952f4360f89402869fa4e';

/// See also [matchStream].
@ProviderFor(matchStream)
final matchStreamProvider = AutoDisposeStreamProvider<List<Match>>.internal(
  matchStream,
  name: r'matchStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$matchStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MatchStreamRef = AutoDisposeStreamProviderRef<List<Match>>;
String _$matchNotifierHash() => r'92e5f65bca5316a53db536bbcdecdecc449c7378';

/// See also [MatchNotifier].
@ProviderFor(MatchNotifier)
final matchNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MatchNotifier, void>.internal(
  MatchNotifier.new,
  name: r'matchNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MatchNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
