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
public enum WeatherApi {
    static let requestUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/"
    static let currentParam = "getUltraSrtNcst" // 현재 기준 정보
    static let hourParam = "getUltraSrtFcst" // 단기 시간별 예측 (~6시간)
    static let serviceKey = "O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D"
}

//http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&base_date=20221011&base_time=1940&nx=55&ny=127

public struct UserInfo {
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = UserInfo()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    static var date = Date()
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyyMMdd" //데이터 포멧 설정
        let date = formatter.string(from: Date()) //문자열로 바꾸기
        print("날짜: \(date)")
        return date
    }
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "HHmm" //데이터 포멧 설정
        let time = formatter.string(from: Date()) //문자열로 바꾸기
        print("시간: \(time)")
        return time
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
