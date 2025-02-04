//
//  WeatherViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/3/25.
//

import UIKit
import MapKit
import CoreLocation
import Kingfisher

final class WeatherViewController: UIViewController {
    
    private let weatherView = WeatherView()
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.6543906, longitude: 127.0498832)
    private var isAuthorized: Bool = false

    // MARK: - Lifecycle
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActions()
        locationManager.delegate = self
        checkDeviceLocationService()
    }
    
    // MARK: - Actions
    private func setupActions() {
        weatherView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        weatherView.photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        weatherView.refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    // 현재 위치 가져오기
    @objc private func currentLocationButtonTapped() {
        checkDeviceLocationService()
    }
    
    // 사진 선택하기
    @objc private func photoButtonTapped() {
        let photoVC = PhotoViewController()
        photoVC.photoClosure = { photo in
            self.weatherView.photoImageView.image = photo
        }
        let navVC = UINavigationController(rootViewController: photoVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    // 날씨 새로고침
    @objc private func refreshButtonTapped() {
        weatherView.weatherOverlayView.isHidden = false
        weatherView.weatherInfoLabel.isHidden = false

        getCurrentWeatherOf(currentCoordinate ?? defaultCoordinate)
    }
}

// MARK: - 위치정보 관련
extension WeatherViewController: CLLocationManagerDelegate {
    
    // 1. 디바이스의 위치 서비스 자체가 켜져 있는지 확인
    private func checkDeviceLocationService() {
        print(#function)
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkUserAuthorization()
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "기기의 위치 서비스 권한 없음", message: "설정 > 개인정보 보호 및 보안 > 위치 서비스 항목을 허용해주세요.")
                }
            }
        }
    }
    
    // 2. 유저의 위치 서비스 허용 권한을 확인
    private func checkUserAuthorization() {
        print(#function)

        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("denied")
            isAuthorized = false
            DispatchQueue.main.async {
                self.showAlert(title: "앱의 위치 서비스 권한 없음", message: "앱 설정에서 위치 서비스를 허용해주세요.")
            }
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            isAuthorized = true
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
    private func checkCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 4. 위치 정보 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)

        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(coordinate)
            getCurrentWeatherOf(coordinate)
            currentCoordinate = coordinate
        }
        // 성공 후 정보 수집 중지
        locationManager.stopUpdatingLocation()
    }
    
    // 4-1. 위치 정보 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
        setRegionAndAnnotation(defaultCoordinate)
    }
    
    // 5. 위치 정보를 기반으로 Map 에 표시
    private func setRegionAndAnnotation(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        weatherView.mapView.setRegion(region, animated: true)
        
        let allAnnotations = weatherView.mapView.annotations
        weatherView.mapView.removeAnnotations(allAnnotations)
        let annotation = MKPointAnnotation()
        annotation.title = isAuthorized ? "현재 위치" : "청년취업사관학교 도봉캠퍼스"
        annotation.coordinate = coordinate
        weatherView.mapView.addAnnotation(annotation)
     
        getCurrentWeatherOf(coordinate)
    }
}

// MARK: - 네트워크 관련
extension WeatherViewController {
    
    private func getCurrentWeatherOf(_ coordinate: CLLocationCoordinate2D) {
        print(#function)

        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
        NetworkManager.shared.getCurrentWeather(.currentWeather(lat: lat, lon: lon, appId: APIKey.openWeatherKey), CurrentWeather.self) { response in
            switch response {
            case .success(let success):
                self.weatherView.weatherInfoLabel.isHidden = true
                self.weatherView.weatherOverlayView.isHidden = true
                self.weatherView.minTempValue.text = success.main.tempMin.formatted() + "℃"
                self.weatherView.currentTempValue.text = success.main.temp.formatted() + "℃"
                self.weatherView.maxTempValue.text = success.main.tempMax.formatted() + "℃"
                self.weatherView.humidityValue.text = success.main.humidity.formatted() + "%"
                self.weatherView.windSpeedValue.text = success.wind.speed.formatted() + "m/s"
                
                if let weather = success.weather.last {
                    let imageURL = URL(string: OpenWeatherRequest.getIconURL(weather.icon))
                    self.weatherView.weatherImageView.kf.setImage(with: imageURL)
                    self.weatherView.weatherMainLabel.text = weather.description
                    self.navigationItem.title = weather.main
                }
            case .failure(let failure):
                self.showAlert(title: "문제가 발생했어요", message: failure.localizedDescription)
            }
        }
    }
}

// MARK: - Alert
extension WeatherViewController {
    
    private func showAlert(title: String, message: String) {
        print(#function)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if title.contains("앱의 위치 서비스") {
            let settingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                self.setRegionAndAnnotation(self.defaultCoordinate)
            }
            alertController.addAction(settingAction)
            alertController.addAction(cancelAction)
        } else {
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.setRegionAndAnnotation(self.defaultCoordinate)
            }
            alertController.addAction(confirmAction)
        }
        present(alertController, animated: true)
    }
}
