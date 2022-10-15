//
//  DaysDataManager.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/14.
//

import UIKit

final class DaysDataManager {
    private var networkManager = NetworkManager.shared
    private var userInfo = UserInfo.shared
    
    private var daysWeatherData: [DaysWeatherItem]?
    private var currentData: CurrentWeatherModel?
    
    private var daysWeatherModels: [DaysWeatherModel] = []
    
    public func setupDaysNetworks() {
        let today = userInfo.getNow()[1]
        let now = userInfo.getNow()[0]
        
        let nx = 55
        let ny = 127
        
        networkManager.fetchDaysWeatherData(date: today, time: "202210141800", nx: nx, ny: ny) { result in
            //print("VC의 네트워크매니저 FetchData 실행")
            switch result {
            case .success(let successedData):
                self.daysWeatherData = successedData
                // currentData 구조체로 요약 및 생성
                self.processData(data: successedData)
                
                // 비동기 (네트워크 처리 이후 실행되는 코드)
                DispatchQueue.main.async { [self] in
                    // VC로 데이터 전달
                    NotificationCenter.default.post(name: .daysWeatherData, object: self.daysWeatherModels)
                    
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 받아온 데이터 알맞게 프로세싱
    private func processData(data: [DaysWeatherItem]) {
        let model: DaysWeatherItem = data[0]
        var models: [DaysWeatherModel] = []
        models.append(DaysWeatherModel(day: 3, high: model.taMax3, low: model.taMin3))
        models.append(DaysWeatherModel(day: 4, high: model.taMax4, low: model.taMin4))
        models.append(DaysWeatherModel(day: 5, high: model.taMax5, low: model.taMin5))
        models.append(DaysWeatherModel(day: 6, high: model.taMax6, low: model.taMin6))
        models.append(DaysWeatherModel(day: 7, high: model.taMax7, low: model.taMin7))
        models.append(DaysWeatherModel(day: 8, high: model.taMax8, low: model.taMin8))
        models.append(DaysWeatherModel(day: 9, high: model.taMax9, low: model.taMin9))
        models.append(DaysWeatherModel(day: 10, high: model.taMax10, low: model.taMin10))
        
        daysWeatherModels = models
        print(models)
    }
    
    public func getDaysData() -> [DaysWeatherModel] {
        return daysWeatherModels
    }
}
