// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msp_use_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeLoansHash() => r'6d9a0aaf1758d4cdf94d24b1d174010052f889c4';

/// See also [activeLoans].
@ProviderFor(activeLoans)
final activeLoansProvider =
    AutoDisposeFutureProvider<List<Emprestimo>>.internal(
      activeLoans,
      name: r'activeLoansProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeLoansHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveLoansRef = AutoDisposeFutureProviderRef<List<Emprestimo>>;
String _$activeCaixinhasHash() => r'2026c56d70ffde6c079b6a17ad22e8d75d101758';

/// See also [activeCaixinhas].
@ProviderFor(activeCaixinhas)
final activeCaixinhasProvider =
    AutoDisposeFutureProvider<List<Caixinha>>.internal(
      activeCaixinhas,
      name: r'activeCaixinhasProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeCaixinhasHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveCaixinhasRef = AutoDisposeFutureProviderRef<List<Caixinha>>;
String _$mspBalanceHash() => r'9868a2193c8ec49df38fc63d0389cb134537a8ec';

/// See also [mspBalance].
@ProviderFor(mspBalance)
final mspBalanceProvider = AutoDisposeFutureProvider<double>.internal(
  mspBalance,
  name: r'mspBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mspBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MspBalanceRef = AutoDisposeFutureProviderRef<double>;
String _$mspUseControllerHash() => r'3f6f56014990bcf22904ad80c350f29a774f63f7';

/// See also [MspUseController].
@ProviderFor(MspUseController)
final mspUseControllerProvider =
    AutoDisposeAsyncNotifierProvider<MspUseController, void>.internal(
      MspUseController.new,
      name: r'mspUseControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mspUseControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MspUseController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
