//
//  HourDataManager.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/10.
//

import UIKit

class HourDataManager {
    var hourDataArray: [HourWeatherModel] = []
    
    func fetchHourData() {
        hourDataArray = [
        HourWeatherModel(time: 12, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 12),
        HourWeatherModel(time: 15, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 14),
        HourWeatherModel(time: 18, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 16),
        HourWeatherModel(time: 21, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 15),
        HourWeatherModel(time: 00, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 13),
        HourWeatherModel(time: 03, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 10),
        HourWeatherModel(time: 06, image: UIImage(systemName: "cloud.heavyrain.fill"), degree: 9),
        ]
    }
    
    func getHourData() -> [HourWeatherModel] {
        return hourDataArray
    }
    
}


