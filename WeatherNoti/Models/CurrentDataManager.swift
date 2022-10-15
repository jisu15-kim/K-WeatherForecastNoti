//
//  CurrentDataManager.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/13.
//

import UIKit

final class CurrentDataManager {
    private var networkManager = NetworkManager.shared
    private var userInfo = UserInfo.shared
    
    private var hourWeatherData: [CurrentWeatherItem] = []
    private var currentData: CurrentWeatherModel?

    public func setupCurrentNetworks(nx: Int, ny: Int) {
        let today = userInfo.getNow()[1]
        let now = userInfo.getNow()[0]
        
        networkManager.fetchCurrentWeatherData(date: today, time: now, nx: nx, ny: ny) { result in
            switch result {
            case .success(let successedData):
                self.hourWeatherData = successedData
                // currentData 구조체로 요약 및 생성
                self.processData(array: successedData)
                
                // 비동기 (네트워크 처리 이후 실행되는 코드)
                DispatchQueue.main.async { [self] in
                    // VC로 데이터 전달
                    NotificationCenter.default.post(name: .currentWeatherData, object: self.currentData)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func processData(array: [CurrentWeatherItem]) {
        var data: [String:String] = [:]
        let time = array[0].baseTime
        for item in array {
            // 기온의 소수점 반올림
            if item.category == "T1H" {
                let value = Float(item.obsrValue!)
                let newValue = String(Int(round(value!)))
                print("newValue = \(newValue)")
                // 소수점 자른 값 update
                data.updateValue(newValue, forKey: item.category ?? "")
            } else {
                // 기온이 아니라면 그냥 그대로 들어가기
                data.updateValue(item.obsrValue ?? "", forKey: item.category ?? "")
            }
        }
        currentData = CurrentWeatherModel(pty: data["PTY"]!, reh: data["REH"]!, rn1: data["RN1"]!, t1h: data["T1H"]!, uuu: data["UUU"]!, vec: data["VEC"]!, vvv: data["VVV"]!, wsd: data["WSD"]!, time: time!)
    }
    
}

