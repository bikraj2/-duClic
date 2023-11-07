import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.profilePic = '',
    this.bio = '',
    this.groupId = const [],
    this.enrolledCourse = const [],
    this.following = const [],
    this.followers = const [],
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          profilePic: '',
          bio: '',
          points: 0,
          fullName: '',
          groupId: const [],
          enrolledCourse: const [],
          following: const [],
          followers: const [],
        );

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupId;
  final List<String> enrolledCourse;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [uid, email];
  @override
  bool get stringify => false;

  @override
  String toString() {
    return 'Localuser(uid: $uid , email: $email, bio: $bio, points: $points, '
        'fullName: $fullName)';
  }
}
