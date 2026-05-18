import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_text_field.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

class VerifyEmailOtpScreen extends HookConsumerWidget {
  const VerifyEmailOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authState = ref.watch(authUsecaseProvider);
    final otpController = useTextEditingController();
    final otpFocusNode = useFocusNode();
    final otpError = useState<String?>(null);
    final isSubmitting = authState.status == AuthStatus.authenticating;
    final now = useState(DateTime.now());
    final resendAvailableAt = authState.resendAvailableAt;
    final pendingEmail = authState.pendingEmail;

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        now.value = DateTime.now();
      });
      return timer.cancel;
    }, const []);

    final millisecondsRemaining = resendAvailableAt == null
        ? 0
        : resendAvailableAt.millisecondsSinceEpoch -
              now.value.millisecondsSinceEpoch;
    final secondsRemaining = millisecondsRemaining <= 0
        ? 0
        : (millisecondsRemaining / 1000).ceil();
    final canResend = secondsRemaining == 0 && !isSubmitting;

    void clearError() {
      otpError.value = null;
      ref.read(authUsecaseProvider.notifier).clearError();
    }

    Future<void> submitVerification() async {
      FocusScope.of(context).unfocus();
      clearError();
      final otp = otpController.text.trim();
      if (otp.length != 6) {
        otpError.value = 'Enter the 6-digit code we sent to your email.';
        return;
      }

      await ref.read(authUsecaseProvider.notifier).verifyEmailOtp(otp: otp);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  Icons.mark_email_read_outlined,
                                  color: cs.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Check your email',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pendingEmail == null || pendingEmail.isEmpty
                                    ? 'Enter the 6-digit code to continue into your account.'
                                    : 'We sent a 6-digit code to $pendingEmail. Enter it here to continue into your account.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 24),
                              AppTextField(
                                controller: otpController,
                                focusNode: otpFocusNode,
                                hintText: '6-digit code',
                                prefixIcon: Icons.password_rounded,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                enabled: !isSubmitting,
                                errorText:
                                    otpError.value ?? authState.errorMessage,
                                onChanged: (_) => clearError(),
                                onSubmitted: (_) => submitVerification(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                secondsRemaining > 0
                                    ? 'You can request a new code in ${secondsRemaining}s.'
                                    : 'If it has not arrived yet, you can request a fresh code.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 18),
                              FilledButton(
                                onPressed: isSubmitting
                                    ? null
                                    : submitVerification,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                        ),
                                      )
                                    : const Text('Verify email'),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: canResend
                                    ? () => ref
                                          .read(authUsecaseProvider.notifier)
                                          .resendEmailOtp()
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: Text(
                                  secondsRemaining > 0
                                      ? 'Resend code in ${secondsRemaining}s'
                                      : 'Resend code',
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () async {
                                        await ref
                                            .read(authUsecaseProvider.notifier)
                                            .abandonPendingVerification();
                                        if (context.mounted) {
                                          context.go(SGRoute.register.route);
                                        }
                                      },
                                child: const Text('Use a different email'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
