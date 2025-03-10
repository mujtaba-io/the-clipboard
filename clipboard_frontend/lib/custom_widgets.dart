import 'package:flutter/material.dart';

import 'component_particle_button.dart';

void showCustomSnackBar(BuildContext context, String message, bool canDismiss) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF0E0D14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: canDismiss
          ? SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          : null,
    ),
  );
}

Widget newsPopup(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Container(
      width: 400,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F1D), // Darker shade for background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3B9688).withOpacity(0.3), // Subtle mint border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A8277).withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                color: const Color(0xFF4DB6A9),
                size: 26,
              ),
              const SizedBox(width: 12),
              const Text(
                'What\'s New',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Content Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUpdateItem(
                  'Upload Capacity Increased',
                  'You can now upload up to 50 files at once with a size limit of 64 MB per file.',
                ),
                const SizedBox(height: 20),
                _buildUpdateItem(
                  'Bulk Downloads',
                  'Download all your files and texts in a single click with the new bulk download feature.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Button
          Center(
            child: Center(
              child: ParticleButton(
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                backgroundColor: const Color(0xFF2A8277),
                borderRadius: BorderRadius.circular(12),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildUpdateItem(String title, String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Color(0xFF4DB6A9),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        description,
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 14,
          height: 1.5,
          letterSpacing: 0.2,
        ),
      ),
    ],
  );
}

// Example of how to show the popup
void showNewsPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) => newsPopup(context),
  );
}
