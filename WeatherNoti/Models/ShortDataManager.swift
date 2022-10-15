//
//  ShortDataManager.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/13.
//

import UIKit

final class ShortDataManager {
    private var networkManager = NetworkManager.shared
    private var userInfo = UserInfo.shared
    
    private var shortWeatherData: [ShortWeatherItem] = []
    private var currentData: CurrentWeatherModel?
    
    private var shortWeatherModels: [ShortWeatherModel] = []
    
    public func setupShortNetworks(nx: Int, ny: Int) {
        let today = userInfo.getNow()[1]
        let now = userInfo.getNow()[0]

        networkManager.fetchShortWeatherData(date: today, time: now, nx: nx, ny: ny) { result in
            //print("VC의 네트워크매니저 FetchData 실행")
            switch result {
            case .success(let successedData):
                self.shortWeatherData = successedData
                // currentData 구조체로 요약 및 생성
                self.processData(array: successedData)
                
                // 비동기 (네트워크 처리 이후 실행되는 코드)
                DispatchQueue.main.async { [self] in
                    // VC로 데이터 전달
                    NotificationCenter.default.post(name: .shortWeatherData, object: self.shortWeatherModels)
                    
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 받아온 데이터 알맞게 프로세싱
    private func processData(array: [ShortWeatherItem]) {
        var data: [ShortWeatherModel] = []
        var timeCheck = array[0].fcstTime
        var time: String?
        var temp: String?
        var pty: String?
        var sky: String?
        
        for item in array {
            if timeCheck == item.fcstTime {
                time = item.fcstTime
                if item.category == .tmp {
                    temp = item.fcstValue
                } else if item.category == .pty {
                    pty = item.fcstValue
                } else if item.category == .sky {
                    sky = item.fcstValue
                }
            } else {
                data.append(ShortWeatherModel(time: time ?? "", temp: temp ?? "", pty: pty ?? "", sky: sky ?? ""))
                timeCheck = item.fcstTime
                time = item.fcstTime
                if item.category == .tmp {
                    temp = item.fcstValue
                } else if item.category == .pty {
                    pty = item.fcstValue
                } else if item.category == .sky {
                    sky = item.fcstValue
                }
            }
            
        }
        data.append(ShortWeatherModel(time: time ?? "", temp: temp ?? "", pty: pty ?? "", sky: sky ?? ""))
        self.shortWeatherModels = data
        //dump(shortWeatherModels)
    }
    
    func getShortWeatherModels() -> [ShortWeatherModel] {
        return shortWeatherModels
    }
}

