// user_profile.dart

class UserProfile {
  String email;
  String name;
  String bornDate;
  String university;
  String studies;
  String
      pictureUrl; // Esta es la imagen del perfil, puede ser por defecto o personalizada

  // Constructor
  UserProfile({
    required this.email,
    required this.name,
    required this.bornDate,
    required this.university,
    required this.studies,
    this.pictureUrl =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', // Imagen por defecto
  });

  // Método para convertir el objeto a un mapa para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'born_date': bornDate,
      'university': university,
      'studies': studies,
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
      pictureUrl: map['picture'], // Asegúrate de usar 'picture' para la clave
    );
  }
}
