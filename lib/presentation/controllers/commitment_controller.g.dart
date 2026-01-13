// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commitment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeCommitmentsHash() => r'2fabc3a5a34f56691c5b62b70bf7477a14092826';

/// See also [activeCommitments].
@ProviderFor(activeCommitments)
final activeCommitmentsProvider =
    AutoDisposeStreamProvider<List<Compromisso>>.internal(
      activeCommitments,
      name: r'activeCommitmentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeCommitmentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveCommitmentsRef = AutoDisposeStreamProviderRef<List<Compromisso>>;
String _$commitmentControllerHash() =>
    r'ff75504a7d27d04efb87ab9f7dea6c3ed8cb3aae';

/// See also [CommitmentController].
@ProviderFor(CommitmentController)
final commitmentControllerProvider =
    AutoDisposeAsyncNotifierProvider<CommitmentController, void>.internal(
      CommitmentController.new,
      name: r'commitmentControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$commitmentControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CommitmentController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
