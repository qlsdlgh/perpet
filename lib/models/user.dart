class PerpetUser {
  String user_id, user_name, profile_image;

  PerpetUser(this.user_id, this.user_name, this.profile_image);

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'user_name': user_name,
        'profile_image': profile_image,
      };
}
