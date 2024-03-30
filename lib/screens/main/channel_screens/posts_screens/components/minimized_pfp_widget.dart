import 'package:flutter/material.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/utils/image_loading.dart';

Widget buildMinimizedPfp(Post post, double radius) {
  return CircleAvatar(
    radius: 25.0,
    child: ClipOval(
      child: buildImage(post.author.pfpLink, 'assets/images/pfp_outline.png',
          height: 50.0, width: 50.0),
    ),
  );
}
