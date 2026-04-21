import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_text_field.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

const _minRegisterPasswordLength = 8;
const _duplicateEmailMessage =
    'An account with this email already exists. Please sign in.';

enum _RegisterStep { email, details }

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authState = ref.watch(authUsecaseProvider);
    final emailController = useTextEditingController();
    final displayNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final displayNameFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final confirmPasswordFocusNode = useFocusNode();
    final currentStep = useState(_RegisterStep.email);
    final confirmedEmail = useState<String?>(null);
    final emailError = useState<String?>(null);
    final displayNameError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final confirmPasswordError = useState<String?>(null);
    final isCheckingEmail = useState(false);
    final isPasswordVisible = useState(false);
    final isConfirmPasswordVisible = useState(false);
    final didSubmitRegister = useState(false);
    final isSubmitting = authState.status == AuthStatus.authenticating;

    void clearAuthError() {
      ref.read(authUsecaseProvider.notifier).clearError();
    }

    void clearEmailStepError() {
      emailError.value = null;
      clearAuthError();
    }

    void clearDetailErrors() {
      displayNameError.value = null;
      passwordError.value = null;
      confirmPasswordError.value = null;
      clearAuthError();
    }

    void clearDetailInputs() {
      displayNameController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      clearDetailErrors();
    }

    void moveToEmailStepWithError(String message) {
      currentStep.value = _RegisterStep.email;
      confirmedEmail.value = null;
      emailError.value = message;
      clearDetailInputs();
      clearAuthError();
      emailFocusNode.requestFocus();
    }

    ref.listen<AuthState>(authUsecaseProvider, (_, next) {
      if (!didSubmitRegister.value) {
        return;
      }

      if (next.status == AuthStatus.failure) {
        final message =
            next.errorMessage ?? 'Something went wrong. Please try again.';

        if (message == _duplicateEmailMessage) {
          moveToEmailStepWithError(message);
        }
      }

      if (next.status != AuthStatus.authenticating) {
        didSubmitRegister.value = false;
      }
    });

    Future<void> continueToDetails() async {
      FocusScope.of(context).unfocus();
      clearEmailStepError();
      final email = emailController.text.trim();

      if (email.isEmpty || !EmailValidator.validate(email)) {
        emailError.value = 'Enter a valid email address.';
        return;
      }

      isCheckingEmail.value = true;

      try {
        final isAvailable = await ref
            .read(authUsecaseProvider.notifier)
            .checkEmailAvailability(email: email);

        if (!isAvailable) {
          emailError.value = _duplicateEmailMessage;
          return;
        }

        if (confirmedEmail.value != email) {
          clearDetailInputs();
        }

        confirmedEmail.value = email;
        currentStep.value = _RegisterStep.details;
        displayNameFocusNode.requestFocus();
      } on AuthException catch (error) {
        emailError.value = error.message;
      } catch (_) {
        emailError.value = 'Something went wrong. Please try again.';
      } finally {
        isCheckingEmail.value = false;
      }
    }

    Future<void> submitRegistration() async {
      FocusScope.of(context).unfocus();
      clearDetailErrors();
      final email = confirmedEmail.value?.trim() ?? emailController.text.trim();
      final displayName = displayNameController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      var hasError = false;

      if (displayName.isEmpty) {
        displayNameError.value = 'Enter your name.';
        hasError = true;
      }

      if (password.isEmpty) {
        passwordError.value = 'Enter your password.';
        hasError = true;
      } else if (password.length < _minRegisterPasswordLength) {
        passwordError.value =
            'Password must be at least $_minRegisterPasswordLength characters.';
        hasError = true;
      }

      if (confirmPassword.isEmpty) {
        confirmPasswordError.value = 'Confirm your password.';
        hasError = true;
      } else if (confirmPassword != password) {
        confirmPasswordError.value = 'Passwords do not match.';
        hasError = true;
      }

      if (hasError) {
        return;
      }

      didSubmitRegister.value = true;
      await ref.read(authUsecaseProvider.notifier).registerWithEmailPassword(
        displayName: displayName,
        email: email,
        password: password,
      );
    }

    final headerTitle = switch (currentStep.value) {
      _RegisterStep.email => 'Create account',
      _RegisterStep.details => 'Set up your profile',
    };
    final headerSubtitle = switch (currentStep.value) {
      _RegisterStep.email =>
        'Start with your email so we can check if an account already exists.',
      _RegisterStep.details =>
        'Finish your account details for ${confirmedEmail.value ?? emailController.text.trim()}.',
    };

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
                                  currentStep.value == _RegisterStep.email
                                      ? Icons.alternate_email_rounded
                                      : Icons.person_add_alt_1_rounded,
                                  color: cs.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                headerTitle,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                headerSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentStep.value == _RegisterStep.email
                                    ? 'Step 1 of 2'
                                    : 'Step 2 of 2',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (currentStep.value == _RegisterStep.email) ...[
                                AppTextField(
                                  controller: emailController,
                                  focusNode: emailFocusNode,
                                  hintText: 'Email',
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.email],
                                  enabled: !isCheckingEmail.value,
                                  errorText: emailError.value,
                                  onChanged: (_) {
                                    clearEmailStepError();
                                  },
                                  onSubmitted: (_) => continueToDetails(),
                                ),
                                const SizedBox(height: 18),
                                FilledButton(
                                  onPressed: isCheckingEmail.value
                                      ? null
                                      : continueToDetails,
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: isCheckingEmail.value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                          ),
                                        )
                                      : const Text('Continue'),
                                ),
                              ] else ...[
                                AppTextField(
                                  controller: displayNameController,
                                  focusNode: displayNameFocusNode,
                                  hintText: 'Name',
                                  prefixIcon: Icons.person_outline_rounded,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  enabled: !isSubmitting,
                                  errorText: displayNameError.value,
                                  onChanged: (_) {
                                    displayNameError.value = null;
                                    clearAuthError();
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
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.newPassword,
                                  ],
                                  enabled: !isSubmitting,
                                  errorText: passwordError.value,
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
                                    clearAuthError();
                                  },
                                  onSubmitted: (_) {
                                    confirmPasswordFocusNode.requestFocus();
                                  },
                                ),
                                const SizedBox(height: 14),
                                AppTextField(
                                  controller: confirmPasswordController,
                                  focusNode: confirmPasswordFocusNode,
                                  hintText: 'Confirm password',
                                  prefixIcon: Icons.verified_user_outlined,
                                  obscureText: !isConfirmPasswordVisible.value,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [
                                    AutofillHints.password,
                                  ],
                                  enabled: !isSubmitting,
                                  errorText: confirmPasswordError.value,
                                  suffixIcon: IconButton(
                                    tooltip: isConfirmPasswordVisible.value
                                        ? 'Hide password'
                                        : 'Show password',
                                    onPressed: isSubmitting
                                        ? null
                                        : () =>
                                            isConfirmPasswordVisible.value =
                                                !isConfirmPasswordVisible.value,
                                    icon: Icon(
                                      isConfirmPasswordVisible.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                  onChanged: (_) {
                                    confirmPasswordError.value = null;
                                    clearAuthError();
                                  },
                                  onSubmitted: (_) => submitRegistration(),
                                ),
                                if (authState.errorMessage != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    authState.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: isSubmitting
                                            ? null
                                            : () {
                                                currentStep.value =
                                                    _RegisterStep.email;
                                                clearDetailErrors();
                                                clearAuthError();
                                              },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                        ),
                                        child: const Text('Back'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: isSubmitting
                                            ? null
                                            : submitRegistration,
                                        style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                        ),
                                        child: isSubmitting
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.2,
                                                ),
                                              )
                                            : const Text('Create account'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 18),
                              TextButton(
                                onPressed:
                                    isCheckingEmail.value || isSubmitting
                                        ? null
                                        : () => context.go(SGRoute.login.route),
                                child: const Text(
                                  'Already have an account? Sign in',
                                ),
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
