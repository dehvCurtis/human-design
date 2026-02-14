import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/dream_repository.dart';
import 'models/journal_entry.dart';

/// Provider for the dream repository
final dreamRepositoryProvider = Provider<DreamRepository>((ref) {
  return DreamRepository(supabaseClient: ref.watch(supabaseClientProvider));
});

/// Provider for all dream entries
final dreamEntriesProvider = FutureProvider.autoDispose<List<JournalEntry>>((ref) async {
  final repository = ref.watch(dreamRepositoryProvider);
  return repository.getEntries(type: JournalEntryType.dream);
});

/// Provider for all journal entries
final journalEntriesProvider = FutureProvider.autoDispose<List<JournalEntry>>((ref) async {
  final repository = ref.watch(dreamRepositoryProvider);
  return repository.getEntries(type: JournalEntryType.journal);
});

/// Provider for a single entry by ID
final journalEntryProvider =
    FutureProvider.family<JournalEntry?, String>((ref, id) async {
  final repository = ref.watch(dreamRepositoryProvider);
  return repository.getEntry(id);
});
