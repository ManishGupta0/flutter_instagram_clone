class MyDateUtils {
  static String dateAgo(DateTime date) {
    var duration = DateTime.now().difference(date);
    if (duration.inSeconds < 60) {
      return "a few moments ago";
    }
    if (duration.inMinutes < 60) {
      return "${duration.inMinutes} minutes ago";
    }
    if (duration.inHours < 24) {
      return "${duration.inHours} hours ago";
    }
    if (duration.inDays < 31) {
      return "${duration.inDays} days ago";
    }
    if (duration.inDays > 365) {
      return "${duration.inDays ~/ 365} years ago";
    }
    return "${duration.inDays ~/ 30} months ago";
  }
}
