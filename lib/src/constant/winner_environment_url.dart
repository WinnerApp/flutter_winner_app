import 'package:flutter_winner_app/flutter_winner_app.dart';

class WinnerEnvironmentUrl {
  final BaseUrl debug;
  final BaseUrl profile;
  final BaseUrl release;
  WinnerEnvironmentUrl({
    required String debug,
    required String profile,
    required String release,
  })  : debug = BaseUrl(debug),
        profile = BaseUrl(profile),
        release = BaseUrl(release);
}
