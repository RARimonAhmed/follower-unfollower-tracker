import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.fetchProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchProfile,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.profile.value == null) {
          return const Center(child: Text('No profile data available'));
        }

        final profile = controller.profile.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profile.profilePictureUrl.toString(),),
              ),
              const SizedBox(height: 16),
              Text(
                profile.username.toString(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(profile.name.toString()),
              if (profile.biography != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(profile.biography!),
                ),
              if (profile.website != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    profile.website!,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        profile.mediaCount.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('Posts'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        profile.followersCount.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('Followers'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        profile.followsCount.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('Following'),
                    ],
                  ),
                ],
              ),
              if (profile.isUserFollowBusiness != null || profile.isBusinessFollowUser != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (profile.isUserFollowBusiness ?? false)
                        const Chip(label: Text('Follows you')),
                      if (profile.isBusinessFollowUser ?? false)
                        const Chip(label: Text('Following')),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}