import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  final String description;
  final String username;
  final datePublished;
  final String profImage;
  final likes;
  final String commentId;
  final String uid;

  const Comment({
    required this.description,
    required this.username,
    required this.datePublished,
    required this.profImage,
    required this.likes,
    required this.commentId,
    required this.uid
    ,});

  Map<String, dynamic> toJson() => {
    'descriptiom' : description,
    'uid' : uid,
    'username' : username,
    'datePublished' : datePublished,
    'postfImage' : profImage,
    'commentId' : commentId,
    'likes' : likes,
  };
  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      description: snapshot['description'],
      uid: snapshot['uid'],
      commentId: snapshot['commentId'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}