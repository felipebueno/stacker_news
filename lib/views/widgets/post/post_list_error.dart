import 'package:flutter/material.dart';

class PostListError extends StatelessWidget {
  const PostListError(String message, {super.key}) : _message = message;

  final String _message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Error loading posts:'),
          Text(_message),
        ],
      ),
    );
  }
}
