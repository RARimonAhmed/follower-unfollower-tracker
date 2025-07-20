import 'package:get/get.dart';
import 'package:instagram_clone/api_service.dart';
import 'package:instagram_clone/auth_controller.dart';
import 'package:instagram_clone/comment_model.dart';

class CommentController extends GetxController {
  final RxList<Comment> comments = <Comment>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPosting = false.obs;
  final ApiService _apiService = Get.find();

  Future<void> postComment(String mediaId, String text) async {
    try {
      isPosting.value = true;
      final success = await _apiService.postComment(
        mediaId,
        text,
        Get.find<AuthController>().accessToken.value,
      );

      if (success) {
        comments.insert(0, Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          username: Get.find<AuthController>().userId.value,
          timestamp: DateTime.now(),
        ));
        Get.snackbar('Success', 'Comment posted');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to post comment: ${e.toString()}');
    } finally {
      isPosting.value = false;
    }
  }

  Future<void> fetchComments(String mediaId) async {
    try {
      isLoading.value = true;
      // In a real app, you would fetch comments from the API
      await Future.delayed(const Duration(seconds: 1));
      comments.assignAll([
        Comment(
          id: '1',
          text: 'Great post!',
          username: 'user1',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Comment(
          id: '2',
          text: 'Nice content!',
          username: 'user2',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load comments: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}