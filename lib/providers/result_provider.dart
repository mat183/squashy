import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:squashy/models/result.dart';
import 'package:squashy/repositories/result_repository.dart';

part 'result_provider.g.dart';

@riverpod
ResultRepository resultRepository(Ref ref) => ResultRepository();

@riverpod
class ResultNotifier extends _$ResultNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> addResult(Result result) async {
    state = const AsyncLoading();
    try {
      await ref.read(resultRepositoryProvider).addResult(result);
      state = const AsyncData(null);
    } catch (error) {
      throw Exception(
          'Something went wrong during result addition: ${error.toString()}');
    }
  }

  Future<void> removeResult(String resultId) async {
    state = const AsyncLoading();
    try {
      await ref.read(resultRepositoryProvider).removeResult(resultId);
      state = const AsyncData(null);
    } catch (error) {
      throw Exception(
          'Something went wrong during result removal: ${error.toString()}');
    }
  }
}

@riverpod
Stream<List<Result>> resultStream(Ref ref) {
  return ref.watch(resultRepositoryProvider).watchResults();
}
