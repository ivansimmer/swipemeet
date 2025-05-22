class UserProfile {
  String email;
  String name;
  String bornDate;
  String university;
  String studies;
  String ubicacion;
  List<String> intereses;
  String pictureUrl;
  List<String> connections;
  List<String> academic_interests;
  List<String> favorite_activities;
  String description;
  String favorite_song;
  String favorite_song_image;
  String photo1;
  String photo2;
  String photo3;
  String photo4;


  // Constructor
  UserProfile({
    required this.email,
    required this.name,
    required this.bornDate,
    required this.university,
    required this.studies,
    required this.ubicacion,
    required this.intereses,
    required this.connections,
    required this.academic_interests,
    required this.favorite_activities,
    required this.description,
    required this.favorite_song,
    required this.favorite_song_image,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
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
      'connections': connections,
      'picture': pictureUrl,
      'favorite_song': favorite_song,
      'favorite_song_image': favorite_song_image,
      'academic_interests': academic_interests,
      'description': description,
      'favorite_activities': favorite_activities,
      'photo1': photo1,
      'photo2': photo2,
      'photo3': photo3,
      'photo4': photo4,
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
      connections: map['connections'],
      pictureUrl: map['picture'],
      favorite_song: map['favorite_song'],
      favorite_song_image: map['favorite_song_image'],
      favorite_activities: map['favorite_activities'],
      description: map['description'],
      photo1: map['photo1'],
      photo2: map['photo2'],
      photo3: map['photo3'],
      photo4: map['photo4'],
      academic_interests: map['academic_interests']
    );
  }
}
