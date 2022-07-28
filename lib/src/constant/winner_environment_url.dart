import 'package:flutter_winner_app/flutter_winner_app.dart';

class WinnerEnvironmentUrl<T extends BaseUrl> {
  final T debug;
  final T profile;
  final T release;
  WinnerEnvironmentUrl({
    required String debug,
    required String profile,
    required String release,
  })  : debug = BaseUrl(debug) as T,
        profile = BaseUrl(profile) as T,
        release = BaseUrl(release) as T;

  WinnerEnvironmentUrl.fromUrl({
    required this.debug,
    required this.profile,
    required this.release,
  });
}
