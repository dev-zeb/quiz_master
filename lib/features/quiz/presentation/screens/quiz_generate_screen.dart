import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/core/di/injection.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/ai_quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/ai_quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/ai_quiz_state.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_time_input_field.dart';

class QuizGenerateScreen extends StatefulWidget {
  const QuizGenerateScreen({super.key});

  @override
  State<QuizGenerateScreen> createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<QuizGenerateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _textController = TextEditingController();
  final _extraInfoController = TextEditingController();
  final _numQuestionsController = TextEditingController(text: '5');
  final _minutesController = TextEditingController(text: '02');
  final _secondsController = TextEditingController(text: '00');

  final _scrollController = ScrollController();

  int _selectedTabIndex = 0;
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _textController.dispose();
    _extraInfoController.dispose();
    _numQuestionsController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final isTimeError = minutes == 0 && seconds == 0;

    return BlocProvider<AiQuizBloc>(
      create: (_) => getIt<AiQuizBloc>(),
      child: BlocConsumer<AiQuizBloc, AiQuizState>(
        listenWhen: (prev, cur) =>
            prev.quiz != cur.quiz || prev.error != cur.error,
        listener: (context, state) {
          if (state.quiz != null) {
            context.push('/editor', extra: state.quiz);
            return;
          }

          if (state.error != null) {
            final msg = _mapAiErrorToMessage(state.error!);
            showSnackBar(
              context: context,
              message: msg,
              backgroundColor: colorScheme.error,
              textColor: colorScheme.onError,
            );
          }
        },
        builder: (context, aiState) {
          return Scaffold(
            appBar: customAppBar(
              context: context,
              title: 'Generate Quiz with AI',
              hasBackButton: true,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        interactive: true,
                        scrollbarOrientation: ScrollbarOrientation.right,
                        thickness: 6.0,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTabSection(colorScheme),
                                const SizedBox(height: 8),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _selectedTabIndex == 0
                                      ? _buildTextInputSection(colorScheme)
                                      : _buildFileInputSection(colorScheme),
                                ),
                                const SizedBox(height: 8),
                                _buildQuizConfigurationSection(
                                  colorScheme,
                                  isTimeError,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF764BA2,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: aiState.isLoading
                                    ? null
                                    : () => _generateQuiz(context, colorScheme),
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Generate quiz',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                if (aiState.isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _mapAiErrorToMessage(Object error) {
    final s = error.toString();

    if (s.contains('File too large')) return s;
    if (s.contains('bytes were null')) {
      return 'Could not read the file. Please re-pick it (or try a smaller PDF).';
    }
    if (s.toLowerCase().contains('timeout')) {
      return 'AI generation is taking too long. Please try again or use a smaller file.';
    }
    if (s.contains('too large for the AI model')) {
      return 'Document is too large. Try a smaller file or fewer pages.';
    }

    // During dev, this is helpful. In release, keep generic.
    return 'Error generating quiz: $s';
  }

  // --- UI sections (unchanged from your version except where needed) ---

  Widget _buildTabSection(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Input Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabItem(
                    icon: Icons.text_fields_rounded,
                    label: 'Text',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                    colorScheme: colorScheme,
                  ),
                ),
                Expanded(
                  child: _buildTabItem(
                    icon: Icons.attach_file_rounded,
                    label: 'File',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: isSelected
              ? const [Color(0xFF667EEA), Color(0xFF764BA2)]
              : [
                  colorScheme.primary.withValues(alpha: 0.25),
                  colorScheme.primary.withValues(alpha: 0.25),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInputSection(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your content',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _textController,
              maxLines: 8,
              decoration: InputDecoration(
                border: _outlineBorder(colorScheme, 0.1),
                enabledBorder: _outlineBorder(colorScheme, 0.35),
                focusedBorder: _outlineBorder(colorScheme, 0.60),
                hintText:
                    'Paste or type the content to generate questions from ...',
                hintStyle: TextStyle(
                  color: colorScheme.primary.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              validator: (value) {
                if (_selectedTabIndex == 0) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some text to generate questions.';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _outlineBorder(ColorScheme colorScheme, double alpha) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colorScheme.primary.withValues(alpha: alpha),
        width: alpha < 0.5 ? 0.35 : 0.60,
      ),
    );
  }

  Widget _buildFileInputSection(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload a file',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
              child: Column(
                children: [
                  Icon(
                    _selectedFile != null
                        ? Icons.check_circle
                        : Icons.cloud_upload,
                    color: _selectedFile != null
                        ? const Color(0xFF764BA2)
                        : colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedFile?.name ?? 'No file selected',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedFile != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _buildChooseFileButton(colorScheme),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Additional Instructions (Optional)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _extraInfoController,
              maxLines: 3,
              decoration: InputDecoration(
                border: _outlineBorder(colorScheme, 0.1),
                enabledBorder: _outlineBorder(colorScheme, 0.35),
                focusedBorder: _outlineBorder(colorScheme, 0.60),
                hintText:
                    'E.g. "Focus on React basics", "Make questions easy", etc.',
                hintStyle: TextStyle(
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChooseFileButton(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _selectedFile != null ? 'Change File' : 'Choose File',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizConfigurationSection(
    ColorScheme colorScheme,
    bool isTimeError,
  ) {
    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Configuration',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.quiz, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Number of questions',
                  style: TextStyle(fontSize: 16, color: colorScheme.primary),
                ),
                const Spacer(),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _numQuestionsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 1.0,
                        ),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                    ),
                    validator: (value) {
                      final n = int.tryParse(value ?? '') ?? 0;
                      if (n <= 0) return 'Enter a number';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.timer, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quiz time limit",
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (isTimeError)
                      Text(
                        AppStrings.pleaseEnterValidTimeDuration,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                QuizTimeInputField(
                  label: 'min',
                  textEditingController: _minutesController,
                  onChanged: (_) => setState(() {}),
                ),
                QuizTimeInputField(
                  label: 'sec',
                  textEditingController: _secondsController,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _selectedFile = result.files.first);
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context: context, message: 'Failed to pick file: $e');
    }
  }

  Future<void> _generateQuiz(
    BuildContext blocContext,
    ColorScheme colorScheme,
  ) async {
    final currentUser = getIt<AuthRepository>().currentUser;

    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    if (minutes == 0 && seconds == 0) {
      showSnackBar(
        context: context,
        message: AppStrings.pleaseEnterValidTimeDuration,
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final numQuestions = int.tryParse(_numQuestionsController.text.trim()) ?? 0;
    if (numQuestions <= 0) {
      showSnackBar(
        context: context,
        message: 'Please enter a valid number of questions.',
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
      );
      return;
    }

    final durationSeconds = (minutes * 60) + seconds;

    if (_selectedTabIndex == 1) {
      final file = _selectedFile;
      if (file == null) {
        showSnackBar(
          context: context,
          message: 'Please select a file.',
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
        );
        return;
      }

      blocContext.read<AiQuizBloc>().add(
        AiQuizGenerateFromFileRequested(
          file: file,
          numQuestions: numQuestions,
          userId: currentUser?.id,
          durationSeconds: durationSeconds,
          extraInstructions: _extraInfoController.text.trim().isEmpty
              ? null
              : _extraInfoController.text.trim(),
        ),
      );
    } else {
      final text = _textController.text.trim();
      if (text.isEmpty) {
        showSnackBar(
          context: context,
          message: 'Please enter some text.',
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
        );
        return;
      }

      blocContext.read<AiQuizBloc>().add(
        AiQuizGenerateFromTextRequested(
          text: text,
          numQuestions: numQuestions,
          userId: currentUser?.id,
          durationSeconds: durationSeconds,
        ),
      );
    }
  }
}
