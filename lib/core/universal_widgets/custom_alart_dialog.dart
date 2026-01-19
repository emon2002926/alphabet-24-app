import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final AlertType type;
  final bool showCancelButton;
  final Widget? customContent;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.type = AlertType.info,
    this.showCancelButton = true,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFF2E2E2E)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(isDarkMode),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 32,
                color: _getIconColor(isDarkMode),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDarkMode
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            // Custom content (optional)
            if (customContent != null) ...[
              const SizedBox(height: 20),
              customContent!,
            ],

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    child: _buildCancelButton(context, isDarkMode),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: _buildConfirmButton(context, isDarkMode),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
          onCancel?.call();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDarkMode
                ? const Color(0xFF2E2E2E)
                : Colors.grey.shade300,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          cancelText ?? "Cancel",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          onConfirm?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(isDarkMode),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          confirmText ?? "Confirm",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.error:
        return Icons.error;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.info:
        return Icons.info;
      case AlertType.question:
        return Icons.help;
    }
  }

  Color _getIconColor(bool isDarkMode) {
    switch (type) {
      case AlertType.success:
        return const Color(0xFF00D9B5);
      case AlertType.error:
        return Colors.red.shade400;
      case AlertType.warning:
        return Colors.orange.shade400;
      case AlertType.info:
        return Colors.blue.shade400;
      case AlertType.question:
        return const Color(0xFF00D9B5);
    }
  }

  Color _getIconBackgroundColor(bool isDarkMode) {
    switch (type) {
      case AlertType.success:
        return const Color(0xFF00D9B5).withOpacity(0.1);
      case AlertType.error:
        return Colors.red.withOpacity(0.1);
      case AlertType.warning:
        return Colors.orange.withOpacity(0.1);
      case AlertType.info:
        return Colors.blue.withOpacity(0.1);
      case AlertType.question:
        return const Color(0xFF00D9B5).withOpacity(0.1);
    }
  }

  Color _getButtonColor(bool isDarkMode) {
    switch (type) {
      case AlertType.success:
        return const Color(0xFF00D9B5);
      case AlertType.error:
        return Colors.red.shade400;
      case AlertType.warning:
        return Colors.orange.shade400;
      case AlertType.info:
      case AlertType.question:
        return isDarkMode
            ? const Color(0xFF00D9B5)
            : const Color(0xFF006B5A);
    }
  }

  // Static helper methods
  static Future<void> show(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmText,
        String? cancelText,
        VoidCallback? onConfirm,
        VoidCallback? onCancel,
        AlertType type = AlertType.info,
        bool showCancelButton = true,
        Widget? customContent,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        type: type,
        showCancelButton: showCancelButton,
        customContent: customContent,
      ),
    );
  }

  static Future<void> success(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmText,
        VoidCallback? onConfirm,
      }) {
    return show(
      context,
      title: title,
      message: message,
      confirmText: confirmText ?? "OK",
      onConfirm: onConfirm,
      type: AlertType.success,
      showCancelButton: false,
    );
  }

  static Future<void> error(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmText,
        VoidCallback? onConfirm,
      }) {
    return show(
      context,
      title: title,
      message: message,
      confirmText: confirmText ?? "OK",
      onConfirm: onConfirm,
      type: AlertType.error,
      showCancelButton: false,
    );
  }

  static Future<void> warning(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmText,
        String? cancelText,
        VoidCallback? onConfirm,
        VoidCallback? onCancel,
      }) {
    return show(
      context,
      title: title,
      message: message,
      confirmText: confirmText ?? "Continue",
      cancelText: cancelText ?? "Cancel",
      onConfirm: onConfirm,
      onCancel: onCancel,
      type: AlertType.warning,
      showCancelButton: true,
    );
  }

  static Future<void> confirm(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmText,
        String? cancelText,
        VoidCallback? onConfirm,
        VoidCallback? onCancel,
      }) {
    return show(
      context,
      title: title,
      message: message,
      confirmText: confirmText ?? "Confirm",
      cancelText: cancelText ?? "Cancel",
      onConfirm: onConfirm,
      onCancel: onCancel,
      type: AlertType.question,
      showCancelButton: true,
    );
  }
}

enum AlertType {
  success,
  error,
  warning,
  info,
  question,
}

/*
 * use case
 // Success Dialog
SAlertDialog.success(
  context,
  title: "Success!",
  message: "Your profile has been updated successfully.",
  onConfirm: () {
    print("User acknowledged success");
  },
);

// Error Dialog
SAlertDialog.error(
  context,
  title: "Error",
  message: "Failed to update your profile. Please try again.",
  onConfirm: () {
    print("User acknowledged error");
  },
);

// Warning Dialog
SAlertDialog.warning(
  context,
  title: "Are you sure?",
  message: "This action cannot be undone. Do you want to continue?",
  confirmText: "Yes, Continue",
  cancelText: "No, Cancel",
  onConfirm: () {
    print("User confirmed warning");
  },
  onCancel: () {
    print("User cancelled");
  },
);

// Confirmation Dialog
SAlertDialog.confirm(
  context,
  title: "Delete Account",
  message: "Are you sure you want to delete your account? This action is permanent.",
  confirmText: "Delete",
  cancelText: "Keep Account",
  onConfirm: () {
    // Delete account logic
  },
  onCancel: () {
    // Cancel action
  },
);

// Custom Dialog with custom content
SAlertDialog.show(
  context,
  title: "Rate Our App",
  message: "How would you rate your experience?",
  confirmText: "Submit",
  customContent: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      5,
      (index) => Icon(
        Icons.star,
        color: Colors.amber,
        size: 32,
      ),
    ),
  ),
  type: AlertType.info,
  onConfirm: () {
    print("Rating submitted");
  },
);


 */