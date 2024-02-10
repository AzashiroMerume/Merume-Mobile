import 'package:flutter/material.dart';
import 'package:merume_mobile/models/post_model.dart';

Widget buildMinimizedPfp(Post post, double radius) {
  return CircleAvatar(
    radius: 25.0,
    backgroundImage: post.author.pfpLink != null
        ? NetworkImage(post.author.pfpLink!)
        : const AssetImage('assets/images/pfp_outline.png') as ImageProvider,
  );
}
