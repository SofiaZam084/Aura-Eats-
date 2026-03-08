class Usuario {
  final String id;
  final String email;
  final String nombre;
  final String? telefono;
  final String? direccion;
  final DateTime fechaRegistro;
  final String? fotoUrl;

  Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    this.telefono,
    this.direccion,
    required this.fechaRegistro,
    this.fotoUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'],
      direccion: json['direccion'],
      fechaRegistro: json['fechaRegistro'] != null 
          ? DateTime.parse(json['fechaRegistro'])
          : DateTime.now(),
      fotoUrl: json['fotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'telefono': telefono,
      'direccion': direccion,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'fotoUrl': fotoUrl,
    };
  }

  Usuario copyWith({
    String? nombre,
    String? telefono,
    String? direccion,
    String? fotoUrl,
  }) {
    return Usuario(
      id: id,
      email: email,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      fechaRegistro: fechaRegistro,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }
}