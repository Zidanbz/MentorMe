import 'package:flutter/material.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/global/Fontstyle.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  final bool showLogo;

  const LoadingDialog({
    super.key,
    this.message,
    this.showLogo = true,
  });

  static void show(
    BuildContext context, {
    String? message,
    bool showLogo = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(
          message: message,
          showLogo: showLogo,
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFe0fff3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFe0fff3),
              const Color(0xFFe0fff3).withOpacity(0.8),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF339989).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLogo) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF339989), Color(0xFF3c493f)],
                    ),
                  ),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: const Color(0xFF339989),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      message ?? AppStrings.loading,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xFF3c493f),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
