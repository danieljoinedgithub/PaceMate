import 'dart:math';

class Corrida {
  // Atributos principais
  double pace_instantaneo = 0.0; // Pace instantâneo em min/km
  double pace_medio = 0.0; // Pace médio em min/km
  double distancia_total = 0.0; // Distância total percorrida em km
  double pace_mais_rapido = double.infinity; // Pace mais rápido em min/km (inicialmente muito alto)

  // Atributos internos para cálculo
  List<Map<String, dynamic>> coordenadas = []; // Lista de coordenadas com timestamps
  DateTime? ultimoTimestamp; // Último timestamp registado
  double? ultimaLatitude; // Última latitude válida
  double? ultimaLongitude; // Última longitude válida
  double tempo_total = 0.0; // Tempo total em minutos
  bool primeira_coordenada = true;
  // Método para adicionar uma nova coordenada e calcular os atributos
  void push_coordenadas(double latitude, double longitude, DateTime timestamp) {
    if (ultimoTimestamp != null) {
      // Verificação de erro: se a distância é muito grande ou o tempo é muito curto
      double dist = _calcular_distancia(ultimaLatitude!, ultimaLongitude!, latitude, longitude);
      double tempo = timestamp.difference(ultimoTimestamp!).inSeconds / 60.0; // Tempo em minutos

      // Calcular velocidade e verificar se é um erro (distância absurda ou velocidade impossível)
      double velocidade = dist / tempo; // Velocidade em km/min

      // Se a velocidade for impossível, ignoramos a coordenada
      if (velocidade > 35/60 || dist > 0.5 || velocidade < 5/60) { // Limite arbitrário de 35 km/min e 0.5 km entre coordenadas
        if(primeira_coordenada){primeira_coordenada = false; return;}
        print("Coordenada inválida detectada, ignorando...");
        print(velocidade*60);
        dist = 0;
        return;
      }

      // Atualizar distância total
      distancia_total += dist;

      // Calcular o pace instantâneo
      pace_instantaneo = tempo / dist;

      // Atualizar o pace mais rápido
      if (pace_instantaneo < pace_mais_rapido) {
        pace_mais_rapido = pace_instantaneo;
      }

      // Atualizar o tempo total
      tempo_total += tempo;

      // Calcular o pace médio (tempo total / distância total)
      pace_medio = tempo_total / distancia_total;

      // Adicionar a coordenada válida à lista
      coordenadas.add({
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
      });
    }

    // Atualizar as últimas coordenadas e timestamp
    ultimoTimestamp = timestamp;
    ultimaLatitude = latitude;
    ultimaLongitude = longitude;
  }

  // Método para calcular a distância entre duas coordenadas geográficas usando a fórmula de Haversine
  double _calcular_distancia(double lat1, double lon1, double lat2, double lon2) {
    const R = 6378.1370; // Raio da Terra em km
    double dLat = _deg_to_rad(lat2 - lat1);
    double dLon = _deg_to_rad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg_to_rad(lat1)) * cos(_deg_to_rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distância em km
  }

  // Conversão de graus para radianos
  double _deg_to_rad(double deg) {
    return deg * (pi / 180.0);
  }
}
