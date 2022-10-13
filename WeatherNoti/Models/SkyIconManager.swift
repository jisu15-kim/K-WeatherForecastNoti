//
//  SkyIconManager.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/13.
//

import UIKit

enum DayNight {
    case day
    case night
}

final class SkyIconManager {
    
    // 하늘 상태를 계산하는 로직
    public func shortSkyIconLogic(sky: Int, pty: Int, time: Int) -> UIImage {
        // 맑음
        let now = dayNightSpliter(time: time)
        
        if sky == 1 {
            if pty == 0 {
                // 청명
                switch now {
                case .day:
                    return UIImage(systemName: "sun.min.fill")!
                case .night:
                    return UIImage(systemName: "moon.stars.fill")!
                }
            } else if pty == 1 {
                // 구름 없고 비
                return UIImage(systemName: "umbrella.fill")!
            } else if pty == 2 {
                // 구름 없고 비 & 눈
                return UIImage(systemName: "thermometer.snowflake")!
            } else if pty == 3 {
                // 구름 없고 눈
                return UIImage(systemName: "snowflake")!
            } else if pty == 4 {
                // 구름 없고 소나기
                return UIImage(systemName: "cloud.rain.fill")!
            }
        } else if sky == 3 { // 구름 많음
            if pty == 0 {
                // 구름만 많음
                switch now {
                case .day:
                    return UIImage(systemName: "cloud.sun.fill")!
                case .night:
                    return UIImage(systemName: "cloud.moon.fill")!
                }
            } else if pty == 1 {
                // 구름 많고 비
                return UIImage(systemName: "cloud.rain.fill")!
            } else if pty == 2 {
                // 구름 많고 비 & 눈
                return UIImage(systemName: "cloud.sleet.fill")!
            } else if pty == 3 {
                // 구름 많고 눈
                return UIImage(systemName: "cloud.snow.fill")!
            } else if pty == 4 {
                // 구름 많고 소나기
                return UIImage(systemName: "cloud.sun.rain.fill")!
            }
        } else if sky == 4 { // 흐림
            if pty == 0 {
                // 흐림
                return UIImage(systemName: "cloud.fill")!
            } else if pty == 1 {
                // 흐리고 비
                return UIImage(systemName: "cloud.rain.fill")!
            } else if pty == 2 {
                // 흐리고 비 & 눈
                return UIImage(systemName: "cloud.sleet.fill")!
            } else if pty == 3 {
                // 흐리고 눈
                return UIImage(systemName: "cloud.snow.fill")!
            } else if pty == 4 {
                // 흐리고 소나기
                return UIImage(systemName: "cloud.heavyrain.fill")!
            }
        } else {
            switch now {
            case .day:
                return UIImage(systemName: "sun.min.fill")!
            case .night:
                return UIImage(systemName: "moon.stars.fill")!
            }
        }
        switch now {
        case .day:
            return UIImage(systemName: "sun.min.fill")!
        case .night:
            return UIImage(systemName: "moon.stars.fill")!
        }
    }
    
    private func dayNightSpliter(time: Int) -> DayNight {
        if 0..<630 ~= time {
            return .night
        } else if 630..<1900 ~= time {
            return .day
        } else {
            return .night
        }
    }
    
    public func currentSkyIconLogic(pty: Int, time: Int) -> UIImage {
        let now = dayNightSpliter(time: time)
        switch pty {
        case 0: // 없음
            switch now {
            case .day:
                return UIImage(systemName: "sun.min.fill")!
            case .night:
                return UIImage(systemName: "moon.stars.fill")!
            }
        case 1: // 비
            return UIImage(systemName: "cloud.rain.fill")!
        case 2: // 비 & 눈
            return UIImage(systemName: "cloud.sleet.fill")!
        case 3, 7: // 눈
            return UIImage(systemName: "cloud.snow.fill")!
        case 5, 6: // 비
            switch now {
            case .day:
                return UIImage(systemName: "cloud.sun.rain.fill")!
            case .night:
                return UIImage(systemName: "cloud.moon.rain.fill")!
            }
        default:
            switch now {
            case .day:
                return UIImage(systemName: "cloud.sun.rain.fill")!
            case .night:
                return UIImage(systemName: "cloud.moon.rain.fill")!
            }
        }
    }
}
