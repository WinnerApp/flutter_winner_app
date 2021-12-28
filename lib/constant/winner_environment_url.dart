import 'package:flutter_winner_app/constant/base_url_enum.dart';

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
