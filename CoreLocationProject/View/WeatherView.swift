//
//  WeatherView.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/3/25.
//

import UIKit
import MapKit
import SnapKit

class WeatherView: UIView {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let weatherOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let weatherMainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.text = "날씨 정보를 불러오는 중..."
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 기온"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let maxTempValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let currentTempLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 기온"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let currentTempValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 기온"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let minTempValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "습도"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let humidityValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "풍속"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let windSpeedValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    // MARK: - View Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        
        [mapView,
         weatherImageView, weatherMainLabel,
         minTempLabel, minTempValue,
         currentTempLabel, currentTempValue,
         maxTempLabel, maxTempValue,
         humidityLabel, humidityValue,
         windSpeedLabel, windSpeedValue,
         weatherOverlayView, weatherInfoLabel,
         currentLocationButton, refreshButton].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(snp.height).multipliedBy(0.5)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(60)
        }
        
        weatherMainLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(weatherImageView)
        }
        
        weatherOverlayView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(mapView)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(20)
        }
        
        maxTempValue.snp.makeConstraints { make in
            make.centerY.equalTo(maxTempLabel)
            make.leading.equalTo(maxTempLabel.snp.trailing).offset(10)
        }
        
        currentTempLabel.snp.makeConstraints { make in
            make.top.equalTo(maxTempLabel.snp.bottom).offset(20)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(20)
        }
        
        currentTempValue.snp.makeConstraints { make in
            make.centerY.equalTo(currentTempLabel)
            make.leading.equalTo(currentTempLabel.snp.trailing).offset(10)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTempLabel.snp.bottom).offset(20)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(20)
        }
        
        minTempValue.snp.makeConstraints { make in
            make.centerY.equalTo(minTempLabel)
            make.leading.equalTo(minTempLabel.snp.trailing).offset(10)
        }

        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalTo(minTempValue.snp.trailing).offset(20)
        }
        
        humidityValue.snp.makeConstraints { make in
            make.centerY.equalTo(humidityLabel)
            make.leading.equalTo(humidityLabel.snp.trailing).offset(10)
        }

        windSpeedLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(20)
            make.leading.equalTo(minTempValue.snp.trailing).offset(20)
        }
        
        windSpeedValue.snp.makeConstraints { make in
            make.centerY.equalTo(windSpeedLabel)
            make.leading.equalTo(windSpeedLabel.snp.trailing).offset(10)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
}
