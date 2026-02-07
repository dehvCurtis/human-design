import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/quiz_providers.dart';
import 'widgets/question_card.dart';
import 'widgets/quiz_progress_bar.dart';

/// Screen for taking a quiz
class QuizTakingScreen extends ConsumerStatefulWidget {
  const QuizTakingScreen({
    super.key,
    required this.quizId,
  });

  final String quizId;

  @override
  ConsumerState<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends ConsumerState<QuizTakingScreen> {
  String? _selectedAnswerId;
  bool _showingResult = false;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    final session = ref.read(quizSessionProvider);
    if (session?.quiz.timeLimit != null) {
      _remainingSeconds = session!.quiz.timeLimit!;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
            if (_remainingSeconds <= 0) {
              _timer?.cancel();
              _handleTimeUp();
            }
          });
        }
      });
    }
  }

  void _handleTimeUp() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.quiz_timesUp),
        content: Text(l10n.quiz_timesUpMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _completeQuiz();
            },
            child: Text(l10n.quiz_ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizSessionProvider);

    if (session == null) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quiz_title)),
        body: Center(
          child: Text(l10n.quiz_noActiveSession),
        ),
      );
    }

    final currentQuestion = session.currentQuestion;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit(context);
        if (shouldExit && context.mounted) {
          ref.read(quizSessionProvider.notifier).reset();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(session.quiz.title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _confirmExit(context)) {
                ref.read(quizSessionProvider.notifier).reset();
                if (context.mounted) {
                  context.pop();
                }
              }
            },
          ),
          actions: [
            if (session.quiz.timeLimit != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: QuizTimer(
                  remainingSeconds: _remainingSeconds,
                  totalSeconds: session.quiz.timeLimit,
                ),
              ),
          ],
        ),
        body: session.isComplete
            ? _buildCompletedView(context, session)
            : currentQuestion == null
                ? _buildNoQuestionsView()
                : _buildQuestionView(context, session, currentQuestion),
      ),
    );
  }

  Widget _buildQuestionView(
    BuildContext context,
    QuizSessionState session,
    currentQuestion,
  ) {
    final answeredQuestions = session.answers.map((a) => a.isCorrect).toList();

    return Column(
      children: [
        // Progress
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuizProgressBar(
                currentQuestion: session.currentQuestionIndex,
                totalQuestions: session.totalQuestions,
                correctAnswers: session.correctCount,
              ),
              const SizedBox(height: 12),
              QuizProgressDots(
                totalQuestions: session.totalQuestions,
                currentQuestion: session.currentQuestionIndex,
                answeredQuestions: answeredQuestions,
              ),
            ],
          ),
        ),
        // Question
        Expanded(
          child: QuestionCard(
            question: currentQuestion,
            selectedAnswerId: _selectedAnswerId,
            showResult: _showingResult,
            onAnswerSelected: _handleAnswerSelected,
          ),
        ),
        // Bottom action button
        _buildBottomButton(context, session),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, QuizSessionState session) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: _showingResult
              ? ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    session.currentQuestionIndex >= session.totalQuestions - 1
                        ? l10n.quiz_seeResults
                        : l10n.quiz_nextQuestion,
                  ),
                )
              : ElevatedButton(
                  onPressed: _selectedAnswerId != null ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.dividerLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.quiz_submitAnswer),
                ),
        ),
      ),
    );
  }

  Widget _buildCompletedView(BuildContext context, QuizSessionState session) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            l10n.common_loading,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuestionsView() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(l10n.quiz_noQuestionsAvailable),
    );
  }

  void _handleAnswerSelected(String answerId) {
    setState(() {
      _selectedAnswerId = answerId;
    });
  }

  void _handleSubmit() {
    if (_selectedAnswerId == null) return;

    ref.read(quizSessionProvider.notifier).answerQuestion(_selectedAnswerId!);
    setState(() {
      _showingResult = true;
    });
  }

  void _handleNext() {
    final session = ref.read(quizSessionProvider);
    final isLastQuestion = session != null &&
        session.currentQuestionIndex >= session.totalQuestions - 1;

    if (isLastQuestion) {
      _completeQuiz();
    } else {
      ref.read(quizSessionProvider.notifier).nextQuestion();
      setState(() {
        _selectedAnswerId = null;
        _showingResult = false;
      });
    }
  }

  Future<void> _completeQuiz() async {
    _timer?.cancel();

    try {
      final result = await ref.read(quizSessionProvider.notifier).completeQuiz();

      if (result != null && mounted) {
        context.pushReplacement(
          '/quizzes/${widget.quizId}/results/${result.attempt.id}',
          extra: {
            'attempt': result.attempt,
            'isNewBest': result.isNewBest,
            'streakUpdated': result.streakUpdated,
            'pointsEarned': result.pointsEarned,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'complete quiz'))),
        );
      }
    }
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.quiz_exitQuiz),
        content: Text(l10n.quiz_exitWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.quiz_exit),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
