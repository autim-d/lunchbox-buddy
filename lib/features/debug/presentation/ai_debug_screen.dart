import 'dart:async';
import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/ai/ai_client.dart';
import 'package:lunchbox_buddy/core/config/app_config.dart';
import 'package:lunchbox_buddy/core/errors/failures.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/tokens.dart';

/// Structured response model for the debug test request
class DebugSnackIdea {
  const DebugSnackIdea({
    required this.snackName,
    required this.prepTimeMinutes,
    required this.ingredients,
    this.tip,
    required this.rawJson,
  });

  final String snackName;
  final int prepTimeMinutes;
  final List<String> ingredients;
  final String? tip;
  final Map<String, dynamic> rawJson;

  factory DebugSnackIdea.fromJson(Map<String, dynamic> json) {
    final ingList = json['ingredients'] as List<dynamic>?;
    return DebugSnackIdea(
      snackName: json['snackName'] as String? ?? 'وجبة سريعة',
      prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt() ?? 5,
      ingredients:
          ingList?.map((e) => e.toString()).toList() ?? const <String>[],
      tip: json['tip'] as String?,
      rawJson: json,
    );
  }
}

/// Hidden developer debug screen that verifies the end-to-end Firebase AI Logic pipe.
/// Features:
/// - Displays Firebase Auth & App Check status
/// - Sends a tiny structured JSON Schema request to the configured Gemini model
/// - Renders parsed output upon success
/// - Demonstrates clean typed Failure handling when offline without crashing
class AiDebugScreen extends ConsumerStatefulWidget {
  const AiDebugScreen({super.key});

  @override
  ConsumerState<AiDebugScreen> createState() => _AiDebugScreenState();
}

class _AiDebugScreenState extends ConsumerState<AiDebugScreen> {
  bool _isLoading = false;
  DebugSnackIdea? _successResult;
  Failure? _errorResult;

  static final Schema _snackSchema = Schema.object(
    properties: {
      'snackName': Schema.string(
        description: 'Arabic name of the suggested snack',
      ),
      'prepTimeMinutes': Schema.integer(
        description: 'Estimated preparation time in minutes',
      ),
      'ingredients': Schema.array(
        items: Schema.string(),
        description: 'Two main ingredients',
      ),
      'tip': Schema.string(
        description: 'A brief, practical kitchen tip in Arabic',
      ),
    },
  );

  Future<void> _runDebugTest() async {
    unawaited(HapticFeedback.lightImpact());
    setState(() {
      _isLoading = true;
      _successResult = null;
      _errorResult = null;
    });

    final aiClient = ref.read(aiClientProvider);

    final result = await aiClient.generateStructured<DebugSnackIdea>(
      prompt: 'اقترحي تصبيرة سريعة وصحية للأطفال بمكونين فقط مع وقت التحضير بالدقائق ونصيحة صغيرة.',
      responseSchema: _snackSchema,
      parser: DebugSnackIdea.fromJson,
      systemInstruction: 'أنتِ مساعدة ذكية متخصصة في وجبات الأطفال الصحية. التزمي دائماً بإرجاع بيانات JSON مطابقة للمخطط بدقة.',
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      result.when(
        success: (snack) {
          _successResult = snack;
          HapticFeedback.lightImpact();
        },
        error: (failure) {
          _errorResult = failure;
          HapticFeedback.heavyImpact();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final config = ref.watch(appConfigProvider);
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (_) {
      user = null;
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'فاحص Firebase AI Logic (Debug)',
          style: typography.titleLarge.copyWith(color: colors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Environment & Configuration Info Card
            Container(
              padding: EdgeInsetsDirectional.all(spacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(radii.card),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.hub_rounded,
                        color: colors.secondary,
                        size: 20.0,
                      ),
                      SizedBox(width: spacing.xs),
                      Text(
                        'بيئة التشغيل والاتصال',
                        style: typography.titleSmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16.0),
                  _buildInfoRow(
                    'Firebase Auth:',
                    user != null
                        ? 'مفعل (UID: ${user.uid.substring(0, 8)}...)'
                        : 'غير مسجل',
                  ),
                  _buildInfoRow('Active Gemini Model:', config.geminiModel),
                  _buildInfoRow(
                    'Request Timeout:',
                    '${config.requestTimeoutSeconds} ثوانٍ',
                  ),
                  _buildInfoRow('Max Retries:', '${config.maxRetries} محاولة'),
                  _buildInfoRow(
                    'App Check Backend:',
                    'Gemini Developer API (Free)',
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xl),

            // 2. Action Test Button
            AppButton(
              label: _isLoading
                  ? 'جاري الاتصال بـ Gemini...'
                  : 'اختبار إرسال استعلام مهيكل (Ping AI)',
              icon: Icons.bolt_rounded,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _runDebugTest,
            ),
            SizedBox(height: spacing.xl),

            // 3. Results Section
            if (_successResult != null) _buildSuccessCard(_successResult!),
            if (_errorResult != null) _buildFailureCard(_errorResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    const colors = AppTokens.colors;
    const typography = AppTokens.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: typography.labelSmall.copyWith(color: colors.textSecondary),
          ),
          Text(
            value,
            style: typography.labelSmall.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(DebugSnackIdea snack) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final jsonPretty = const JsonEncoder.withIndent('  ')
        .convert(snack.rawJson);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(color: colors.secondary.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: colors.secondary,
                size: 24.0,
              ),
              SizedBox(width: spacing.xs),
              Text(
                'استجابة مهيكلة ناجحة (Schema Validated)',
                style: typography.titleSmall.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Text(
            snack.snackName,
            style: typography.titleLarge.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            'وقت التحضير: ${snack.prepTimeMinutes} دقائق',
            style: typography.labelMedium.copyWith(color: colors.primary),
          ),
          SizedBox(height: spacing.sm),
          Text(
            'المكونات:',
            style: typography.labelSmall.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.xs),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: snack.ingredients.map((ing) {
              return Chip(
                label: Text(ing),
                backgroundColor: colors.surfaceSubtle,
                side: BorderSide(color: colors.borderSubtle),
              );
            }).toList(),
          ),
          if (snack.tip != null) ...[
            SizedBox(height: spacing.sm),
            Container(
              padding: EdgeInsetsDirectional.all(spacing.sm),
              decoration: BoxDecoration(
                color: colors.secondaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(radii.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, size: 18.0),
                  SizedBox(width: spacing.xs),
                  Expanded(
                    child: Text(
                      snack.tip!,
                      style: typography.bodySmall.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: spacing.md),
          const Divider(),
          Text(
            'JSON Response:',
            style: typography.labelSmall.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: spacing.xs),
          Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.all(spacing.sm),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: BorderRadius.circular(radii.sm),
            ),
            child: Text(
              jsonPretty,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureCard(Failure failure) {
    const colors = AppTokens.colors;
    const spacing = AppTokens.spacing;
    const radii = AppTokens.radii;
    const typography = AppTokens.typography;

    final failureType = failure.runtimeType.toString();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.card),
        border: Border.all(color: colors.error.withValues(alpha: 0.5)),
      ),
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colors.error,
                size: 24.0,
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: Text(
                  'فشل الاستعلام النظيف ($failureType)',
                  style: typography.titleSmall.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Text(
            failure.message,
            style: typography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          if (failure.cause != null) ...[
            SizedBox(height: spacing.xs),
            Text(
              'Cause: ${failure.cause}',
              style: typography.bodySmall.copyWith(color: colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
