import 'package:firebase_auth/firebase_auth.dart';

/// Maps low-level FirebaseAuthException codes into UX-friendly messages
/// that are safe to show to end users.
String mapAuthErrorToMessage(Object error, {required bool isSignIn}) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return "That email address doesn't look right. Double-check and try again.";

      case 'user-disabled':
        return 'This account has been disabled. Please contact support if this is unexpected.';

      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return isSignIn
            ? 'Incorrect email or password. Please try again.'
            : 'Those credentials are not valid.';

      case 'email-already-in-use':
        return 'An account already exists with this email. Try signing in instead.';

      case 'weak-password':
        return 'That password is too weak. Try something longer with a mix of characters.';

      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';

      case 'operation-not-allowed':
        return 'This sign-in method is not available right now.';

      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';

      default:
        // Use Firebase's own message if available, otherwise fallback.
        return error.message ??
            'Something went wrong while signing you ${isSignIn ? 'in' : 'up'}. Please try again.';
    }
  }

  return 'Something went wrong. Please try again.';
}
