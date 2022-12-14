//
//  HourWeather.swift
//  WeatherNoti
//
//  Created by κΉμ§μ on 2022/10/11.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct CurrentWeatherData: Codable {
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
    let items: CurrentWeatherItems
    let pageNo: Int?
    let numOfRows: Int?
    let totalCount: Int?
}

// MARK: - Items
struct CurrentWeatherItems: Codable {
    let item: [CurrentWeatherItem]
}

// MARK: - Item
struct CurrentWeatherItem: Codable {
    let baseDate: String?
    let baseTime: String?
    let category: String? // π₯
    let fcstDate: String?
    let fcstTime: String?
    let fcstValue: String? // π₯
    let nx: Int?
    let ny: Int?
    let obsrValue: String?
}

// MARK: - Header
struct Header: Codable {
    let resultCode: String?
    let resultMsg: String?
}

// Processed Data
struct CurrentWeatherModel {
    let pty: String // κ°μλ
    let reh: String //μ΅λ
    let rn1: String // 1μκ° κ°μλ
    var t1h: String //κΈ°μ¨
    let uuu: String //νμ
    let vec: String // νν₯ ??
    let vvv: String // νμ ??
    let wsd: String // νμ ??
    let time: String
}

enum PTYModel: Int {
    case none, rain, rainSnow, snow, shower, rainDrop, rainDropSnow, snowWind
}
