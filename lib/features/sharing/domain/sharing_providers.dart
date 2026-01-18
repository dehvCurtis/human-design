import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/sharing_repository.dart';
import 'models/sharing.dart';

/// Provider for the SharingRepository
final sharingRepositoryProvider = Provider<SharingRepository>((ref) {
  return SharingRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for user's share links
final myShareLinksProvider = FutureProvider<List<SharedLink>>((ref) async {
  final repository = ref.watch(sharingRepositoryProvider);
  return repository.getMyShareLinks();
});

/// Provider for chart data from share token
final sharedChartProvider = FutureProvider.family<ChartSummaryData?, String>((ref, token) async {
  final repository = ref.watch(sharingRepositoryProvider);
  return repository.getChartByShareToken(token);
});

/// Notifier for sharing operations
class SharingNotifier extends Notifier<SharingState> {
  @override
  SharingState build() => const SharingState();

  SharingRepository get _repository => ref.read(sharingRepositoryProvider);

  /// Create a share link for a chart
  Future<SharedLink> createChartShareLink({
    required String chartId,
    Duration? expiresIn,
  }) async {
    state = state.copyWith(isCreatingLink: true);

    try {
      final link = await _repository.createChartShareLink(
        chartId: chartId,
        expiresIn: expiresIn,
      );

      ref.invalidate(myShareLinksProvider);
      state = state.copyWith(
        isCreatingLink: false,
        lastCreatedLink: link,
      );

      return link;
    } catch (e) {
      state = state.copyWith(isCreatingLink: false, error: e.toString());
      rethrow;
    }
  }

  /// Revoke a share link
  Future<void> revokeShareLink(String shareId) async {
    await _repository.revokeShareLink(shareId);
    ref.invalidate(myShareLinksProvider);
  }

  /// Record a share view
  Future<void> recordShareView(String token) async {
    await _repository.recordShareView(token);
  }

  /// Generate compatibility report
  CompatibilityReport generateCompatibilityReport({
    required ChartSummaryData person1,
    required ChartSummaryData person2,
  }) {
    return _repository.generateCompatibilityReport(
      person1: person1,
      person2: person2,
    );
  }

  /// Capture a widget as an image
  Future<Uint8List?> captureWidgetAsImage(
    GlobalKey key, {
    double pixelRatio = 3.0,
  }) async {
    state = state.copyWith(isExporting: true);

    try {
      final bytes = await _repository.captureWidgetAsImage(
        key,
        pixelRatio: pixelRatio,
      );

      state = state.copyWith(isExporting: false);
      return bytes;
    } catch (e) {
      state = state.copyWith(isExporting: false, error: e.toString());
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearLastCreatedLink() {
    state = state.copyWith(lastCreatedLink: null);
  }
}

final sharingNotifierProvider = NotifierProvider<SharingNotifier, SharingState>(() {
  return SharingNotifier();
});

/// State class for sharing operations
class SharingState {
  const SharingState({
    this.isCreatingLink = false,
    this.isExporting = false,
    this.lastCreatedLink,
    this.error,
  });

  final bool isCreatingLink;
  final bool isExporting;
  final SharedLink? lastCreatedLink;
  final String? error;

  SharingState copyWith({
    bool? isCreatingLink,
    bool? isExporting,
    SharedLink? lastCreatedLink,
    String? error,
  }) {
    return SharingState(
      isCreatingLink: isCreatingLink ?? this.isCreatingLink,
      isExporting: isExporting ?? this.isExporting,
      lastCreatedLink: lastCreatedLink ?? this.lastCreatedLink,
      error: error,
    );
  }
}

/// Provider for generating a compatibility report
final compatibilityReportProvider = Provider.family<CompatibilityReport, CompatibilityParams>((ref, params) {
  final repository = ref.watch(sharingRepositoryProvider);
  return repository.generateCompatibilityReport(
    person1: params.person1,
    person2: params.person2,
  );
});

/// Parameters for compatibility report
class CompatibilityParams {
  const CompatibilityParams({
    required this.person1,
    required this.person2,
  });

  final ChartSummaryData person1;
  final ChartSummaryData person2;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompatibilityParams &&
        other.person1.name == person1.name &&
        other.person2.name == person2.name;
  }

  @override
  int get hashCode => Object.hash(person1.name, person2.name);
}
