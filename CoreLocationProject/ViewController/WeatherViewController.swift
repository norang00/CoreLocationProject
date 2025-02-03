//
//  WeatherViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/3/25.
//

import UIKit
import MapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let weatherView = WeatherView()
    
    let locationManager = CLLocationManager()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.6543906, longitude: 127.0498832)
    
    // MARK: - Lifecycle
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActions()
        locationManager.delegate = self
    }
    
    private func setupActions() {
        weatherView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        weatherView.refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        checkDeviceLocationService()
    }
    
    @objc private func refreshButtonTapped() {
        // 날씨 새로고침 구현
        getCurrentWeatherOf(defaultCoordinate)
    }
}

// MARK: - 위치정보 관련
extension WeatherViewController: CLLocationManagerDelegate {
    
    // 1. 디바이스의 위치 서비스 자체가 켜져 있는지 확인
    func checkDeviceLocationService() {
        print(#function)
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkUserAuthorization()
            }
        }
    }
    
    // 2. 유저의 위치 서비스 허용 권한을 확인
    func checkUserAuthorization() {
        print(#function)

        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("설정으로 이동하는 Alert를 추가해야 함")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            checkCurrentLocation()
        default:
            print("default")
        }
    }
    
    // 2-1. 유저가 위치 정보 권한을 변경했을 때, 다시 한번 서비스 허용 권한을 확인
    // iOS14+
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserAuthorization()
    }
    // iOS14-
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserAuthorization()
    }
    
    // 3. 위치 정보 수집을 시작
    func checkCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 4. 위치 정보 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)

        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(coordinate)
        }
        
        // 성공 후 정보 수집 중지
        locationManager.stopUpdatingLocation()
    }
    
    // 4-1. 위치 정보 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    // 5. 위치 정보를 기반으로 Map 에 표시
    func setRegionAndAnnotation(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        weatherView.mapView.setRegion(region, animated: true)
    }
}

// MARK: - 네트워크 관련
extension WeatherViewController {
    
    func getCurrentWeatherOf(_ coordinate: CLLocationCoordinate2D) {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        print(#function, lat, lon)
        NetworkManager.shared.getCurrentWeather(.currentWeather(lat: lat, lon: lon, appId: APIKey.openWeatherKey), CurrentWeather.self) { Result in
            print(Result)
        }
    }
    
}
