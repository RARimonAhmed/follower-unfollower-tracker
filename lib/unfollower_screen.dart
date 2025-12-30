import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/follower_controller.dart';

class UnfollowerScreen extends StatelessWidget {
  const UnfollowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FollowerController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unfollowers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchFollowers,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column();

        // if (controller.unfollowers.isEmpty) {
        //   return const Center(child: Text('No unfollowers detected'));
        // }
        //
        // return ListView.builder(
        //   itemCount: controller.unfollowers.length,
        //   itemBuilder: (context, index) {
        //     final unfollower = controller.unfollowers[index];
        //     return ListTile(
        //       leading: CircleAvatar(
        //         backgroundImage: NetworkImage(unfollower.profilePictureUrl),
        //       ),
        //       title: Text(unfollower.username),
        //       subtitle: const Text('No longer follows you'),
        //     );
        //   },
        // );
      }),
    );
  }
}