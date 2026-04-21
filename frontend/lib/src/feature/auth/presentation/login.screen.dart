import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_text_field.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

enum _LoginAttempt { emailPassword, google }

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authState = ref.watch(authUsecaseProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final isPasswordVisible = useState(false);
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final lastLoginAttempt = useState<_LoginAttempt?>(null);
    final isSubmitting = authState.status == AuthStatus.authenticating;
    final showGoogleButton = ref.watch(isMobileGoogleSignInSupportedProvider);
    final authErrorMessage = authState.errorMessage;
    final isGoogleAttempt = lastLoginAttempt.value == _LoginAttempt.google;
    final passwordFieldError =
        passwordError.value ?? (isGoogleAttempt ? null : authErrorMessage);
    final googleAuthError = isGoogleAttempt ? authErrorMessage : null;

    void clearErrors() {
      emailError.value = null;
      passwordError.value = null;
      lastLoginAttempt.value = null;
      ref.read(authUsecaseProvider.notifier).clearError();
    }

    Future<void> submit() async {
      FocusScope.of(context).unfocus();
      clearErrors();
      final email = emailController.text.trim();
      final password = passwordController.text;
      var hasError = false;

      if (email.isEmpty || !EmailValidator.validate(email)) {
        emailError.value = 'Enter a valid email address.';
        hasError = true;
      }

      if (password.isEmpty) {
        passwordError.value = 'Enter your password.';
        hasError = true;
      }

      if (hasError) {
        return;
      }

      lastLoginAttempt.value = _LoginAttempt.emailPassword;
      await ref
          .read(authUsecaseProvider.notifier)
          .signInWithEmailPassword(email: email, password: password);
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
                                  Icons.checklist_rounded,
                                  color: cs.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Todos',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Welcome back',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to continue where you left off.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),

                              const SizedBox(height: 24),
                              AppTextField(
                                controller: emailController,
                                focusNode: emailFocusNode,
                                hintText: 'Email',
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                enabled: !isSubmitting,
                                errorText: emailError.value,
                                onChanged: (_) {
                                  emailError.value = null;
                                  lastLoginAttempt.value = null;
                                  ref
                                      .read(authUsecaseProvider.notifier)
                                      .clearError();
                                },
                                onSubmitted: (_) {
                                  passwordFocusNode.requestFocus();
                                },
                              ),
                              const SizedBox(height: 14),
                              AppTextField(
                                controller: passwordController,
                                focusNode: passwordFocusNode,
                                hintText: 'Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: !isPasswordVisible.value,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                enabled: !isSubmitting,
                                errorText: passwordFieldError,
                                suffixIcon: IconButton(
                                  tooltip: isPasswordVisible.value
                                      ? 'Hide password'
                                      : 'Show password',
                                  onPressed: isSubmitting
                                      ? null
                                      : () => isPasswordVisible.value =
                                            !isPasswordVisible.value,
                                  icon: Icon(
                                    isPasswordVisible.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                                onChanged: (_) {
                                  passwordError.value = null;
                                  lastLoginAttempt.value = null;
                                  ref
                                      .read(authUsecaseProvider.notifier)
                                      .clearError();
                                },
                                onSubmitted: (_) => submit(),
                              ),
                              const SizedBox(height: 18),
                              FilledButton(
                                onPressed: isSubmitting ? null : submit,
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
                                    : const Text('Sign in'),
                              ),
                              if (showGoogleButton) ...[
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: cs.outlineVariant,
                                        height: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'or continue with',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: cs.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: cs.outlineVariant,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                OutlinedButton.icon(
                                  onPressed: isSubmitting
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          clearErrors();
                                          lastLoginAttempt.value =
                                              _LoginAttempt.google;
                                          ref
                                              .read(
                                                authUsecaseProvider.notifier,
                                              )
                                              .signInWithGoogle();
                                        },
                                  icon: const Icon(Icons.login_rounded),
                                  label: const Text('Continue with Google'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                                if (googleAuthError != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    googleAuthError,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                              const SizedBox(height: 18),
                              Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 2,
                                children: [
                                  const TextButton(
                                    onPressed: null,
                                    child: Text('Forgot password?'),
                                  ),
                                  Text(
                                    kIsWeb ? 'Web login only' : 'Mobile ready',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: isSubmitting
                                        ? null
                                        : () => context.go(
                                            SGRoute.register.route,
                                          ),
                                    child: Text(
                                      "Don't have an account? Sign up",
                                    ),
                                  ),
                                ],
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
