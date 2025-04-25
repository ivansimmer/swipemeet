class UserProfile {
  String email;
  String name;
  String bornDate;
  String university;
  String studies;
  String ubicacion;
  List<String> intereses;
  String pictureUrl;

  // Constructor
  UserProfile({
    required this.email,
    required this.name,
    required this.bornDate,
    required this.university,
    required this.studies,
    required this.ubicacion,
    required this.intereses,
    this.pictureUrl = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', // Imagen por defecto
  });

  // Método para convertir el objeto a un mapa para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'born_date': bornDate,
      'university': university,
      'studies': studies,
      'ubicacion': ubicacion,
      'intereses': intereses,
      'picture': pictureUrl,
    };
  }

  // Método estático para crear un objeto desde un mapa (útil si lo recuperas de Firestore)
  static UserProfile fromMap(Map<String, dynamic> map) {
    return UserProfile(
      email: map['email'],
      name: map['name'],
      bornDate: map['born_date'],
      university: map['university'],
      studies: map['studies'],
      ubicacion: map['ubicacion'],
      intereses: map['intereses'],
      pictureUrl: map['picture'],
    );
  }
}
