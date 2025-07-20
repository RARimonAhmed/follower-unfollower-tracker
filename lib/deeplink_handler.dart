import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepLinkHandler extends GetxController {
  final AuthController authController;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  DeepLinkHandler({required this.authController});

  Future<void> initDeepLinking() async {
    _appLinks = AppLinks();

    // Handle initial link (app opened from a link)
    await _handleInitialLink();

    // Listen for link changes while app is running
    _listenForDeepLinks();
  }

  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _processDeepLink(initialUri);
      }

      // Fallback for older versions
      final Uri? latestUri = await _appLinks.getLatestLink();
      if (latestUri != null) {
        _processDeepLink(latestUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial/latest link: $e');
    }
  }

  void _listenForDeepLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _processDeepLink(uri);
      }
    }, onError: (err) {
      debugPrint('Deep link error: $err');
    });
  }

  void _processDeepLink(Uri uri) {
    debugPrint('Processing deep link: $uri');

    // Handle Instagram OAuth callback
    if (uri.path.startsWith('/auth/')) {
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];

      if (error != null) {
        Get.snackbar('Error', 'Authorization failed: $error');
        return;
      }

      if (code != null) {
        authController.handleDeepLinkAuth(code);
      }
    }
  }

  Future<void> launchDeepLink(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
}