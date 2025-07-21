import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/follower_controller.dart';
import 'package:instagram_clone/follower_model.dart';

class FollowerScreen extends StatelessWidget {
  const FollowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FollowerController controller = Get.put(FollowerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshFollowers,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.followers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.followers.isEmpty) {
          return const Center(child: Text('No followers found'));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshFollowers,
          child: ListView.builder(
            itemCount: controller.followers.length + (controller.hasMoreFollowers.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.followers.length) {
                // Load more indicator
                if (!controller.isLoading.value) {
                  controller.fetchFollowers();
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final follower = controller.followers[index];
              return FollowerTile(
                follower: follower,
                onUnfollow: (){
                  // controller.unfollowUser(follower.id);
                },
              );
            },
          ),
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
        radius: 24,
      ),
      title: Row(
        children: [
          Text(
            follower.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (follower.isVerified)
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Icon(Icons.verified, size: 16, color: Colors.blue),
            ),
        ],
      ),
      subtitle: Text(
        follower.fullName,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person_remove, color: Colors.red),
                  title: const Text('Unfollow', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    onUnfollow();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
      onTap: () {
        // You could navigate to the follower's profile here
      },
    );
  }
}