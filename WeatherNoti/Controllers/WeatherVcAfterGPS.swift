//
//  UserLocation.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/16.
//

import Foundation
import CoreLocation
import UIKit

extension WeatherViewController: CLLocationManagerDelegate, UIAlertViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GPS를 받아오는데 에러 발생")
    }
    // MARK: - GPS 데이터 받아오기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            // GEOCODER 주소변환 호출
            findAddr(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
            let lati = Double(currentLocation.coordinate.latitude)
            let longi = Double(currentLocation.coordinate.longitude)
            let XYData = gpsManager.convertGRID_GPS(mode: 0, lat_X: lati, lng_Y: longi)
            nx = XYData.x
            ny = XYData.y
            // 변환한 X/Y 값을 활용해 호출
            fetchData()
        }
        // 에러시 Alert
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                // LocationManager 세팅
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 제공 불가", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - 위도/경도 찾기
    func findAddr(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        print("Location : \(findLocation)")
        // MARK: - GEOCODER 주소 변환
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                var areaName: String = ""
                var locationName: String = ""
                if let area: String = address.last?.administrativeArea{
                    areaName = area
                }
                if let name: String = address.last?.name {
                    locationName = name
                }
                DispatchQueue.main.async {
                    self.shortLocateLabel.text = "\(areaName), \(locationName)"
                }
            }
        })
    }
    
    //- MARK: 위치 허용 선택했을 때 처리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            firstSetting()
            break
        case .authorizedAlways:
            firstSetting()
            break
        case .restricted :
            break
        case .denied :
            break
        default:
            break
        }
    }
    
    func firstSetting() {
        currentLocation = locationManager.location
    }
}
