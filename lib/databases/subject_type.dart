class SubjectType {
  // TODO add subject that correspond to the collage
  static const List<String> subjectTypes = [
    'Polski',
    'Matematyka',
    'Biologia',
    'Chemia',
    'Informatyka',
    'Angielski',
    'Niemiecki',
    'Fizyka',
    'Geografia',
    'Historia',
  ];
  // TODO add not only to politechnika poznanska
  static const List<String> collageTypes = [
    'Architektura',
    'Architektura wnętrz',
    'Automatyka i robotyka',
    'Bioinformatyka',
    'Budownictwo',
    'Budownictwo zrównoważone',
    'Edukacja techniczno-informatyczna',
    'ELECTRICAL ENGINEERING',
    'Elektroenergetyka',
    'Elektromobilność',
    'Elektronika i telekomunikacja',
    'Elektrotechnika',
    'Energetyka',
    'ENERGETYKA PRZEMYSŁOWA I ODNAWIALNA',
    'Fizyka techniczna',
    'Informatyka',
    'Inżynieria bezpieczeństwa',
    'Inżynieria biomedyczna',
    'Inżynieria chemiczna i procesowa',
    'Inżynieria cyklu życia produktu',
    'Inżynieria farmaceutyczna',
    'Inżynieria lotnicza',
    'INŻYNIERIA MATERIAŁOWA',
    'Inżynieria środowiska',
    'Inżynieria zarządzania',
    'Logistyka',
    'Lotnictwo',
    'Lotnictwo i kosmonautyka',
    'Matematyka w technice',
    'Mechanika i budowa maszyn',
    'Mechanika i budowa pojazdów',
    'Mechatronika',
    'Sztuczna Inteligencja',
    'Technologia chemiczna',
    'Technologie obiegu zamkniętego',
    'Teleinformatyka',
    'Transport',
    'Zarządzanie i inżynieria produkcji',
    'Zielona energia',
  ];
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(const Duration(seconds: 0));

    return collageTypes.where((element) {
      return element.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
