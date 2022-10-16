//
//  Constants.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/11.
//

import UIKit

//MARK: - Name Space 만들기

// 데이터 영역에 저장 (열거형, 구조체 다 가능 / 전역 변수로도 선언 가능)
// 사용하게될 API 문자열 묶음
struct TodayModel {
    let year: String
    let month: String
    let date: String
    let dayOfWeek: String
}

public enum WeatherApi {
    static let requestUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/"
    static let currentParam = "getUltraSrtNcst" // 현재 기준 정보
    static let shortParam = "getVilageFcst" // 단기 시간별 예측
    static let serviceKey = "O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D"
    static let daysRequestUrl = "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa"
    //    static let daysParam = "MidFcstInfoService"
    static let daysServiceKey = "O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D"
}

//https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&regId=11B10101&tmFc=202210141800

public struct UserInfo {
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = UserInfo()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    //    static var date = Date()
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyyMMdd" //데이터 포멧 설정
        let date = formatter.string(from: Date()) //문자열로 바꾸기
        return date
    }
    
    func getCurrentTitleDate() -> TodayModel {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MMM-dd-EE" //데이터 포멧 설정
        let date = formatter.string(from: Date()) //문자열로 바꾸기
        let newDate = date.split(separator: "-")
        let model = TodayModel(year: String(newDate[0]), month: String(newDate[1]), date: String(newDate[2]), dayOfWeek: String(newDate[3]))
        return model
    }
    
    private func getYesterdayDate() -> String {
        let yesterday = Date(timeIntervalSinceNow:-86400)
        let yFormatter = DateFormatter()
        yFormatter.dateStyle = .long
        yFormatter.dateFormat = "yyyyMMdd" //데이터 포멧 설정
        let date = yFormatter.string(from: yesterday) //문자열로 바꾸기
        return date
    }
    
    func getNow() -> [String] {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "HHmm" //데이터 포멧 설정
        let time = Int(formatter.string(from: Date()))! //문자열로 바꾸기
        
        if 0 <= time && time < 230 {
            return ["2300", getYesterdayDate()]
        } else if 230 <= time && time < 530 {
            return ["0200", getCurrentDate()]
        } else if 530..<803 ~= time {
            return ["0500", getCurrentDate()]
        } else if 830..<1130 ~= time {
            return ["0800", getCurrentDate()]
        }  else if 1130..<1430 ~= time {
            return ["1100", getCurrentDate()]
        } else if 1430..<1730 ~= time {
            return ["1400", getCurrentDate()]
        } else if 1730..<2030 ~= time {
            return ["1700", getCurrentDate()]
        } else if 2030..<2330 ~= time {
            return ["2000", getCurrentDate()]
        } else if 2330..<2359 ~= time {
            return ["2300", getCurrentDate()]
        } else {
            // 혹시.. 모든값이 오류라면 ?
            return ["0200", getYesterdayDate()]
        }
    }
    
    func getDaysNowData() -> [String] {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "HHmm" //데이터 포멧 설정
        let time = Int(formatter.string(from: Date()))! //문자열로 바꾸기
        
        if 0 <= time && time < 600 {
            return ["1800", getYesterdayDate()]
        } else if 600 <= time && time < 1800 {
            return ["600", getCurrentDate()]
        } else if 1800..<2359 ~= time {
            return ["1800", getCurrentDate()]
        } else {
            // 혹시.. 모든값이 오류라면 ?
            return ["1800", getYesterdayDate()]
        }
    }
    
    
    // 사용하게될 Cell 문자열 묶음
    public struct Cell {
        static let musicCellIdentifier = "MusicCell"
        static let musicCollectionViewCellIdentifier = "MusicCollectionViewCell"
        private init() {} // 구조체의 Instance를 만들어낼 수 없음
    }
    
    
    
    // 컬렉션뷰 구성을 위한 설정
    public struct CVCell {
        static let spacingWitdh: CGFloat = 1
        static let cellColumns: CGFloat = 3
        private init() {}
    }
    
    
    //let REQUEST_URL = "https://itunes.apple.com/search?"
}


extension Date {
    
    func dayofTheWeek(input: Int) -> String {
        // 현재 시간 - Int
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "HHmm"
        guard let now = Int(formatter.string(from: Date())) else { return "" }
        
        // 업데이트 시간은 06시, 18시 이므로, offset 값
        var offsetDate = 0
        // Offset 값 조절
        if 0 <= now && now < 600 {
            offsetDate = -1
        } else if 600 <= now && now < 1800 {
            offsetDate = 0
        } else if 1800..<2359 ~= now {
            offsetDate = 0
        } else {
            // 혹시.. 모든값이 오류라면 ?
            offsetDate = -1
        }
        
        // 요일 값 정제
        var index = -1 + input
        if index >= 6 {
            index -= 6
        }
        
        // 현재 요일 값
        let dayNumber = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        
        // 최종 값 정제
        var result = index + dayNumber + offsetDate
        if result >= 6 {
            result -= 6
        }
        return daysOfTheWeek[result]
    }
    
    private var daysOfTheWeek: [String] {
        return  ["일", "월", "화", "수", "목", "금", "토"]
    }
}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}
