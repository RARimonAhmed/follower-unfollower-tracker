import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/comment_screen.dart';
import 'package:instagram_clone/follower_controller.dart';
import 'package:instagram_clone/follower_screen.dart';
import 'package:instagram_clone/profile_screen.dart';
import 'package:instagram_clone/storage_service.dart';
import 'package:instagram_clone/unfollower_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => const ProfileScreen()),
              child: const Text('View Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const FollowerScreen()),
              child: const Text('View Followers'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Initialize StorageService first
                await Get.putAsync<StorageService>(() async {
                  final storage = StorageService();
                  return storage.init();
                }, permanent: true);

                Get.put(FollowerController(), permanent: true);
                Get.to(() => const UnfollowerScreen());
              },
              child: const Text('View Unfollowers'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const CommentScreen(mediaId: '123')),
              child: const Text('Post Comment'),
            ),
          ],
        ),
      ),
    );
  }
}