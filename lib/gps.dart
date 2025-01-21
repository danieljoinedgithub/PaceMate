import 'package:location/location.dart';
import 'dart:async';

class GpsService {
  final Location _location = Location();
  late LocationData _currentLocation;
  late StreamSubscription<LocationData> _locationSubscription;
  Function(LocationData)? onLocationUpdate;

  // Método para começar a recolher as coordenadas
  Future<void> startGps(Function(LocationData) onLocationUpdate) async {
    this.onLocationUpdate = onLocationUpdate;

    // Verificar permissões de localização
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        print("O serviço de localização não está ativado.");
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Permissão de localização negada.");
        return;
      }
    }

    // Iniciar a subscrição da localização
    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      _currentLocation = currentLocation;
      if (onLocationUpdate != null) {
        onLocationUpdate(currentLocation); // Chama a função de callback
      }
    });
  }

  // Método para parar a recolha das coordenadas
  Future<void> stopGps() async {
    await _locationSubscription.cancel();
    print("GPS parou.");
  }




}


