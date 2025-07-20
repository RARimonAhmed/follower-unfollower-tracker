import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/commnet_controller.dart';

class CommentScreen extends StatelessWidget {
  final String mediaId;

  const CommentScreen({super.key, required this.mediaId});

  @override
  Widget build(BuildContext context) {
    final CommentController controller = Get.put(CommentController());
    final TextEditingController commentController = TextEditingController();

    controller.fetchComments(mediaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  return ListTile(
                    title: Text(comment.username),
                    subtitle: Text(comment.text),
                    trailing: Text(comment.timestamp.toString()),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                Obx(() {
                  return IconButton(
                    icon: controller.isPosting.value
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.send),
                    onPressed: controller.isPosting.value
                        ? null
                        : () {
                      if (commentController.text.isNotEmpty) {
                        controller.postComment(
                          mediaId,
                          commentController.text,
                        );
                        commentController.clear();
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}