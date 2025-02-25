// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultRepositoryHash() => r'8f88bf027ebfdf519236fe9bab4a27653083a5fc';

/// See also [resultRepository].
@ProviderFor(resultRepository)
final resultRepositoryProvider = AutoDisposeProvider<ResultRepository>.internal(
  resultRepository,
  name: r'resultRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resultRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResultRepositoryRef = AutoDisposeProviderRef<ResultRepository>;
String _$resultStreamHash() => r'583c3af72f1bfe09acfb470aca01cb8e00f2ac61';

/// See also [resultStream].
@ProviderFor(resultStream)
final resultStreamProvider = AutoDisposeStreamProvider<List<Result>>.internal(
  resultStream,
  name: r'resultStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$resultStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResultStreamRef = AutoDisposeStreamProviderRef<List<Result>>;
String _$resultNotifierHash() => r'beee32b8226dd680bf92b20a499279d2412e58a8';

/// See also [ResultNotifier].
@ProviderFor(ResultNotifier)
final resultNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ResultNotifier, void>.internal(
  ResultNotifier.new,
  name: r'resultNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resultNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ResultNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
