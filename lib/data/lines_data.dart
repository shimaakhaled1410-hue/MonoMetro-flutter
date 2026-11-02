import 'package:metro/models/transit_line.dart';

class LineSegmentData {
  const LineSegmentData({
    required this.line,
    required this.stations,
    this.isLoop = false,
  });

  final TransitLine line;
  final List<String> stations;
  final bool isLoop;
}

class WalkLinkData {
  const WalkLinkData({
    required this.from,
    required this.to,
    required this.minutes,
  });

  final String from;
  final String to;
  final int minutes;
}

class LinesData {
  const LinesData._();

  static const int transferMinutes = 7;
  static const int stadiumWalkMinutes = 10;

  static const List<LineSegmentData> segments = [
    LineSegmentData(
      line: TransitLine.line1,
      stations: [
        'Helwan',
        'Ain Helwan',
        'Helwan University',
        'Wadi Hof',
        'Hadayeq Helwan',
        'El Maasara',
        'Tora El Asmant',
        'Kotsika',
        'Tora El Balad',
        'Thakanat El Maadi',
        'Maadi',
        'Hadayeq El Maadi',
        'Dar El Salam',
        'El Zahraa',
        'Mar Girgis',
        'El Malek El Saleh',
        'Sayeda Zeinab',
        'Saad Zaghloul',
        'El Sadat',
        'Nasser',
        'Orabi',
        'El Shohadaa',
        'Ghamra',
        'El Demerdash',
        'Manshiet El Sadr',
        'Kobry El Qobba',
        'Hammamat El Qobba',
        'Saray El Qobba',
        'Hadayeq El Zaitoun',
        'Helmeyet El Zaitoun',
        'El Matareya',
        'Ain Shams',
        'Ezbet El Nakhl',
        'El Marg',
        'New El Marg',
      ],
    ),
    LineSegmentData(
      line: TransitLine.line2,
      stations: [
        'Shubra El Kheima',
        'Kolleyet El Zeraa',
        'Mezhalat',
        'Khalafawy',
        'St. Teresa',
        'Road El-Farag',
        'Masarra',
        'El Shohadaa',
        'Attaba',
        'Mohamed Naguib',
        'El Sadat',
        'Opera',
        'Dokki',
        'El Bohoth',
        'Cairo University',
        'Faisal',
        'Giza',
        'Omm El-Misryeen',
        'Sakiat Mekki',
        'El Mounib',
      ],
    ),
    LineSegmentData(
      line: TransitLine.line3,
      stations: [
        'Adly Mansour',
        'El Haykestep',
        'Omar Ibn El-Khattab',
        'Qobaa',
        'Hesham Barakat',
        'El-Nozha',
        'El-Shams Club',
        'Alf Masken',
        'Heliopolis',
        'Haroun',
        'Al-Ahram',
        'Koleyet El-Banat',
        'Stadium',
        'Fair Zone',
        'Abbassiya',
        'Abdou Pasha',
        'El-Geish',
        'Bab El-Shaaria',
        'Attaba',
        'Nasser',
        'Maspero',
        'Safaa Hijazy',
        'Kit Kat',
      ],
    ),
    LineSegmentData(
      line: TransitLine.line3,
      stations: [
        'Kit Kat',
        'El-Tawfiqiya',
        'Wadi El-Nil',
        'Gamaat El Dowal',
        'Bulak El-Dakrour',
        'Cairo University',
      ],
    ),
    LineSegmentData(
      line: TransitLine.line3,
      stations: [
        'Kit Kat',
        'Sudan',
        'Imbaba',
        'El Bohy',
        'Al Qawmia Al Arabiya',
        'Ring Road',
        'Rod El Farag Corridor',
      ],
    ),
    LineSegmentData(
      line: TransitLine.monorailEast,
      stations: [
        'Stadium (Monorail)',
        'Hisham Barakat (Monorail)',
        'Al-Azhar University',
        '7th District',
        'El-Moshir Ahmed Ismail',
        'Gihan El-Sadat',
        'El-Moshir Tantawy',
        'One Ninety',
        'Air Force Hospital',
        'Al-Narges',
        'Investors',
        'Al-Lotus',
        'Golden Square',
        'Beit El Watan',
        'Al-Fattah Al-Aleem Mosque',
        'R1 District',
        'R2 District',
        'Central Business District',
        'Arts and Culture City',
        'Governmental District',
        'Misr Mosque',
        'Justice City',
      ],
    ),
    LineSegmentData(
      line: TransitLine.brtRing,
      isLoop: true,
      stations: [
        'Adly Mansour',
        'Al Asher Station',
        'Belbeis Road',
        'El Salam',
        'El Marg',
        'Moassasat El Zakat',
        'El Khosos',
        'Mostorod',
        'Bahteem',
        'Shubra El Kheima',
        'Om Bayoumi',
        'Alexandria Agricultural Road',
        'Warraq',
        'Bassous',
        'Rod El Farag Corridor',
        'Al Qawmia Al Arabiya',
        'Bashteel',
        'Ard El Lewa',
        'Mehwar 26th of July',
        'Al Moatamadeya',
        'Zenein',
        'Saft El Laban',
        'Manshiyet El Bakari',
        'Marioutiya',
        'Haram',
        'Faisal (BRT)',
        'Tersa',
        'Al Qasabgi',
        'El Mounib',
        'Bahr El Aazam',
        'Corniche El Nile',
        'El Zahraa (BRT)',
        'Autostrad',
        'Carrefour Maadi',
        'Golf Tunnel',
        'One Ninety',
      ],
    ),
  ];

  static const List<WalkLinkData> walkLinks = [
    WalkLinkData(
      from: 'Stadium',
      to: 'Stadium (Monorail)',
      minutes: stadiumWalkMinutes,
    ),
  ];

  static List<String> namesFor(TransitLine line) {
    final names = <String>[];
    for (final segment in segments) {
      if (segment.line != line) continue;
      for (final name in segment.stations) {
        if (!names.contains(name)) names.add(name);
      }
    }
    return names;
  }
}
