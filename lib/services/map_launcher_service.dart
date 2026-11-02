import 'package:metro/models/station.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncherService {
  const MapLauncherService._();

  static Future<bool> openStation(Station station) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${station.latitude},${station.longitude}',
    );
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return true;
      }
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }
}
