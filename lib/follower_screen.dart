import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/follower_controller.dart';

import 'follower_model.dart';

class FollowerScreen extends StatelessWidget {
  const FollowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FollowerController controller = Get.put(FollowerController());
    controller.fetchFollowerInsights();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchFollowerInsights,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.insights.length,
          itemBuilder: (context, index) {
            final follower = controller.insights[index];
            return Column();
            //   FollowerTile(
            //   follower: follower,
            //   onUnfollow: () => controller.unfollowUser(follower.id),
            // );
          },
        );
      }),
    );
  }
}

class FollowerTile extends StatelessWidget {
  final Follower follower;
  final VoidCallback onUnfollow;

  const FollowerTile({
    super.key,
    required this.follower,
    required this.onUnfollow,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(follower.profilePictureUrl),
      ),
      title: Text(follower.username),
      trailing: ElevatedButton(
        onPressed: onUnfollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text('Unfollow'),
      ),
    );
  }
}