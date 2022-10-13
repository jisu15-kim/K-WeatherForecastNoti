//
//  ShortWeatherModel.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/13.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import UIKit

// MARK: - Welcome
struct ShortWeatherData: Codable {
    let response: ShortResponse
}

// MARK: - Response
struct ShortResponse: Codable {
    let header: ShortHeader
    let body: ShortBody
}

// MARK: - Body
struct ShortBody: Codable {
    let dataType: String
    let items: ShortWeatherItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct ShortWeatherItems: Codable {
    let item: [ShortWeatherItem]
}

// MARK: - Item
struct ShortWeatherItem: Codable {
    let category: Category
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
//    let baseDate: String
//    let baseTime: String
//    let nx, ny: Int
}

enum Category: String, Codable {
    case pcp = "PCP"
    case pop = "POP"
    case pty = "PTY"
    case reh = "REH"
    case sky = "SKY"
    case sno = "SNO"
    case tmn = "TMN"
    case tmp = "TMP"
    case tmx = "TMX"
    case uuu = "UUU"
    case vec = "VEC"
    case vvv = "VVV"
    case wav = "WAV"
    case wsd = "WSD"
}

// MARK: - Header
struct ShortHeader: Codable {
    let resultCode, resultMsg: String
}

struct ShortWeatherModel {
    let time: String
    let temp: String
    let pty: String
    let sky: String
}
