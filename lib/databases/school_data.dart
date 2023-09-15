class BackendService {
  static List<String> list = [
    'II Liceum Ogólnokształcące im. Tadeusza Kościuszki w Kaliszu',
    'III Liceum Ogólnokształcące im. Mikołaja Kopernika w Kaliszu',
    'V Liceum Ogólnokształcące im. Jana III Sobieskiego w Kaliszu',
    'VII Liceum Ogólnokształcące Szkoła Mistrzostwa Sportowego w Zespole Szkół Nr 9 w Kaliszu',
    'Zespół Szkół Ekonomicznych w Kaliszu',
    'Zespół Szkół Gastronomiczno-Hotelarskich im Janka Bytnara "Rudego" w Kaliszu',
    'Zespół Szkół Techniczno-Elektronicznych w Kaliszu',
    'Zespół Szkół Zawodowych im. Zesłańców Sybiru w Kaliszu',
    'I Liceum Ogólnokształcące im. Tadeusza Kościuszki w Koninie',
    'II Liceum Ogólnokształcące im. Krzysztofa Kamila Baczyńskiego w Koninie',
    'Zespół Szkół Górniczo-Energetycznych im.Stanisława Staszica w Koninie',
    'Zespół Szkół Ekonomicznych im. Jana Amosa Komeńskiego w Lesznie',
    'Zespół Szkół Elektroniczno-Telekomunikacyjnych w Lesznie',
    'Zespół Szkół Technicznych Centrum Kształcenia Zawodowego i Ustawicznego im. 55. Poznańskiego Pułku Piechotyw Lesznie',
    'Zespół Szkół Rolniczo-Budowlanych im. „Synów Pułku” w Lesznie',
    'Centrum Kształcenia Zawodowego i Ustawicznego w Poznaniu',
    'Liceum Akademickie w Poznaniu',
    'Liceum Ogólnokształcące Św. Marii Magdaleny w Poznaniu',
    'I Liceum Ogólnokształcące im. Karola Marcinkowskiego w Poznaniu',
    'II Liceum Ogólnokształcące im. Generałowej Zamoyskiej i Heleny Modrzejewskiej w Poznaniu',
    'IV Liceum Ogólnokształcącego im. KEN w Poznaniu',
    'V Liceum Ogólnokształcące im. Klaudyny Potockiej Poznań',
    'VII Liceum Ogólnokształcące im. Dąbrówki w Poznaniu',
    'VIII Liceum Ogólnokształcące im. Adama Mickiewicza w Poznaniu',
    'IX Liceum Ogólnokształcące im.Karola Libelta w Poznaniu',
    'X Liceum Ogólnokształcącego im. Przemysła II w Poznaniu',
    'XI Liceum Ogólnokształcące im. J.W. Zembrzuskich w Poznaniu',
    'XIV Liceum Ogólnokształcące im. Kazimierza Wielkiego w Poznaniu',
    'XV Liceum Ogólnokształcące w Poznaniu',
    'XX Liceum Ogólnokształcące im. K. I. Gałczyńskiego w Poznaniu',
    'XXV Liceum Ogólnokształcące im. Generałowej Jadwigi Zamoyskiej w Poznaniu',
    'XXXVII Liceum Ogólnokształcące z Oddziałami Terapeutycznymi im. Jana Pawła II w Poznaniu',
    'XXXVIII Dwujęzyczne Liceum Ogólnokształcące im. Jana Nowaka-Jeziorańskiego w Poznaniu',
    'Spark Academy - Liceum Ogólnokształcące w Poznaniu',
    'Technikum Energetycznego im. Henryka Zygalskiego w Poznaniu',
    'Technikum nr 19 im. Marszałka Józefa Piłsudskiego w Poznaniu',
    'Wielkopolska Szkoła Medyczna w Poznaniu',
    'Zespół Szkół Budowlano-Drzewnych im. Bolesława Chrobrego w Poznaniu',
    'Zespół Szkół Budowlanych im. Rogera Sławskiego w Poznaniu',
    'Zespół Szkół Budownictwa Nr 1 w Poznaniu',
    'Zespół Szkół Ekonomicznych im. Stanisława Staszica w Poznaniu',
    'Zespół Szkół Elektrycznych Nr 2 im. ks. Piotra Wawrzyniaka w Poznaniu',
    'Zespół Szkół Gastronomicznych im. Karola Libelta w Poznaniu',
    'Zespół Szkół Geodezyjno-Drogowych w Poznaniu',
    'Zespół Szkół Handlowych im. Bohaterów Poznańskiego Czerwca \'56 w Poznaniu',
    'Zespół Szkół Komunikacji im. Hipolita Cegielskiego w Poznaniu',
    'Zespół Szkół Łączności im. Mikołaja Kopernika w Poznaniu',
    'Zespół Szkół Mechanicznych im. Komisji Edukacji Narodowej w Poznaniu',
    'Zespół Szkół Odzieżowych im. Władysława Reymonta w Poznaniu',
    'Zespół Szkół Ogólnokształcących Nr 2 im. Charles de Gaulle\'a w Poznaniu',
    'Zespół Szkół Przyrodniczych w Poznaniu',
    'Zespół Szkół Przemysłu Spożywczego im. J. J. Śniadeckich w Poznaniu',
    'Zespół Szkół Samochodowych im. inż. Tadeusza Tańskiego w Poznaniu',
    'Zespół Szkół Technicznych Tarnowo Podgórne',
    'Zespół Szkół Zawodowych Nr 2 im. Janusza Korczaka w Poznaniu',
    'Zespół Szkół Zawodowych Nr 6 im. Joachima Lelewela w Poznaniu',
    'Zespół Szkół im. Hipolita Cegielskiego w Chodzieży',
    'Liceum Ogólnokształcące im. Janka z Czarnkowa',
    'Zespół Szkół im. Józefa Nojego w Czarnowie',
    'Zespół Szkół Ponadgimnazjalnych im. H. Sienkiewicza w Trzciance',
    'I Liceum Ogólnokształcące im. Bolesława Chrobrego w Gnieźnie',
    'Centrum Kształcenia Zawodowego i Ustawicznego w Gnieźnie Branżowa Szkoła nr 1',
    'Zespół Szkół Ekonomicznych im. Stefana Kardynała Wyszyńskiego Prymasa Tysiąclecia w Gnieźnie',
    'Zespół Szkół Ponadpodstawowych nr 3 w Gnieźnie',
    'Zespół Szkół Ponadpodstawowych im. Dezyderego Chłapowskiego w Witkowie',
    'Zespół Szkół Przyrodniczo-Usługowych im. Stanisława Mikołajczyka w Gnieźnie',
    'Zespół Szkół Technicznych im. Jana Pawła II w Gnieźnie',
    'Zespół Szkół Ogólnokształcących w Gostyniu',
    'Zespół Szkół Rolniczych im. gen. Józefa Wybickiego w Grabonogu',
    'Zespół Szkół Technicznych im. E. Kwiatkowskiego w Grodzisku Wielkopolskim',
    'Wielkopolskie Samorządowe Zespół Placówek Terapeutyczno - Wychowawczych w Cerekwicy Nowej',
    'Zespół Szkół Ponadpodstawowych nr 1 im. Powstańców Wielkopolskich w Jarocinie',
    'Liceum Ogólnokształcące im. Kazimierza Wielkiego w Kole',
    'Zespół Szkół Ekonomiczno-Usługowych im. F. Chopina w Żychlinie',
    'Zespół Szkół Ogólnokształcących i Technicznych w Kleczewie',
    'Zespół Szkół Ponadpodstawowych im. Franciszka Ratajczaka w Kościanie',
    'Zespół Szkół Ponadgimnazjalnych im. Jana Kasprowicza w Nietążkowie',
    'I Liceum Ogólnokształcące im. Hugona Kołłątaja w Krotoszynie',
    'Specjalny Ośrodek Szkolno-Wychowawczy im. Franciszka Ratajczaka w Rydzynie',
    'Liceum Ogólnokształcące w Międzychodzie',
    'Zespół Szkół Nr 2 w Międzychodzie',
    'Zespół Szkół Technicznych w Międzychodzie',
    'Zespół Szkół Rolnicze Centrum Kształcenia Ustawicznego im. gen. D. Chłapowskiego w Trzciance',
    'I Liceum Ogólnokształcące im. ks. Piotra Skargi w Szamotułach',
    'Liceum Ogólnokształcącego im. Powstańców Wielkopolskich w Środzie Wielkopolskiej',
    'Zespół Szkół Rolniczych im. gen. J.H. Dąbrowskiego w Środzie Wielkopolskiej',
    'Centrum Kształcenia NAUKA w Pile',
    'Centrum Kształcenia Zawodowego i Ustawicznego w Wyrzysku',
    'Wielkopolskie Samorządowe Centrum Edukacji i Terapii w Starej Łubiance',
    'II Liceum Ogólnokształcące im. Tadeusza Staniewskiego w Swarzędzu',
    'Liceum Ogólnokształcące im. Mikołaja Kopernika w Puszczykowie',
    'Szkoła w Murowanej Goślinie Zespół Szkół im. Gen. Dezyderego Chłapowskiego w Bolechowie',
    'Technikum w Poznaniu w Zespole Szkół im. Jadwigi i Władysława Zamoyskich w Rokietnicy',
    'Zespół Szkół im. Adama Wodziczki w Mosinie',
    'Zespół Szkół im. Gen. Dezyderego Chłapowskiego w Bolechowie',
    'Zespół Szkół im. Jadwigi i Władysława Zamoyskich w Rokietnicy',
    'Zespół Szkół nr 1 im. Powstańców Wielkopolskich w Swarzędzu',
    'Zespół Szkół nr 2 w Swarzędzu',
    'Zespół Szkół w Kórniku',
    'I Liceum Ogólnokształcące im. Jarosława Dąbrowskiego w Rawiczu',
    'Zespół Szkół im. Jana Pawła II w Jutrosinie',
    'Zespół Szkół Przyrodniczo-Technicznych im. Powstańców Wielkopolskich w Bojanowie',
    'Zespół Szkół Zawodowych im. Stefana Bobrowskiego w Rawiczu',
    'Zespół Placówek Edukacyjno - Wychowawczych w Turku',
    'Zespół Szkół Technicznych im. gen. prof. Sylwestra Kaliskiego w Turku',
    'Zespole Szkół Rolniczych CKP w Kaczkach Średnich',
    'Zespół Szkół Ogólnokształcących im. Marii Skłodowskiej-Curie w Wolsztynie',
    'Zespół Szkół Rolniczych i Technicznych im. Hipolita Cegielskiego w Powodowie',
    'Zespół Szkół Politechnicznych im. Bohaterów Monte Cassino we Wrześni',
    'Zespół Szkół Technicznych i Ogólnokształcących im. gen. dr. Romana Abrahama we Wrześni',
    'Akademia Muzyczna (AM) im. Ignacego Jana Paderewskiego',
    'Akademia Wychowania Fizycznego (AWF) im. Eugeniusza Piaseckiego w Poznaniu',
    'Politechnika Poznańska (PP)',
    'Uniwersytet Artystyczny im. Magdaleny Abakanowicz w Poznaniu',
    'Uniwersytet Ekonomiczny (UE) w Poznaniu',
    'Uniwersytet im. Adama Mickiewicza (UAM) w Poznaniu',
    'Uniwersytet Medyczny (UM) im. Karola Marcinkowskiego w Poznaniu',
    'Uniwersytet Przyrodniczy (UP) w Poznaniu',
  ];
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(const Duration(seconds: 0));

    return list.where((element) {
      return element.contains(query);
    }).toList();
  }
}
