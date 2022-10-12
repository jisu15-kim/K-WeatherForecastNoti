//
//  HourWeather.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/11.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct HourWeatherData: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String?
    let items: HourWeatherItems
    let pageNo: Int?
    let numOfRows: Int?
    let totalCount: Int?
}

// MARK: - Items
struct HourWeatherItems: Codable {
    let item: [HourWeatherItem]
}

// MARK: - Item
struct HourWeatherItem: Codable {
    let baseDate: String?
    let baseTime: String?
    let category: String? // 🔥
    let fcstDate: String?
    let fcstTime: String?
    let fcstValue: String? // 🔥
    let nx: Int?
    let ny: Int?
    let obsrValue: String?
}

// MARK: - Header
struct Header: Codable {
    let resultCode: String?
    let resultMsg: String?
}

struct CurrentWeatherModel {
    let pty: String // 강수량
    let reh: String //습도
    let rn1: String // 1시간 강수량
    let t1h: String //기온
    let uuu: String //풍속
    let vec: String // 풍향 ??
    let vvv: String // 풍속 ??
    let wsd: String // 풍속 ??
}

enum PTYModel: Int {
    case none, rain, rainSnow, snow, shower, rainDrop, rainDropSnow, snowWind
}
