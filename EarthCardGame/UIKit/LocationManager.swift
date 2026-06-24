import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let manager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestOneShotLocation(_ completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            completion(nil)
            self.completion = nil
        @unknown default:
            completion(nil)
            self.completion = nil
        }
    }
    
    func requestOneShotLocationWithLongitudeDirection(_ completion: @escaping (String?) -> Void) {
        requestOneShotLocation { location in
            guard let longitude = location?.coordinate.longitude else {
                completion(nil)
                return
            }
            let direction = longitude >= 0 ? "East" : "West"
            completion(direction)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.manager.requestLocation()
        case .denied, .restricted:
            completion?(nil)
            completion = nil
        case .notDetermined:
            break
        @unknown default:
            completion?(nil)
            completion = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations.last)
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
        completion = nil
    }
}
