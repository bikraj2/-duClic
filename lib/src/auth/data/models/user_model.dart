import 'package:sikshya/core/utils/typedefs.dart';
import 'package:sikshya/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.groupId,
    super.profilePic,
    super.bio,
    super.enrolledCourse,
    super.following,
    super.followers,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          points: 0,
          fullName: '',
        );
  LocalUserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String,
          email: map['email'] as String,
          fullName: map['fullName'] as String,
          profilePic: map['profilePic'] as String,
          points: (map['points'] as num).toInt(),
          bio: map['bio'] as String,
          groupId: (map['groupId'] as List<dynamic>).cast<String>(),
          enrolledCourse:
              (map['enrolledCourse'] as List<dynamic>).cast<String>(),
          followers: (map['followers'] as List<dynamic>).cast<String>(),
          following: (map['following'] as List<dynamic>).cast<String>(),
        );
  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'groupId': groupId,
      'profilePic': profilePic,
      'bio': bio,
      'enrolledCourse': enrolledCourse,
      'following': following,
      'followers': followers,
      'points': points,
    };
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    int? points,
    String? fullName,
    List<String>? groupId,
    String? profilePic,
    String? bio,
    List<String>? enrolledCourse,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupId: groupId ?? this.groupId,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      enrolledCourse: enrolledCourse ?? this.enrolledCourse,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
