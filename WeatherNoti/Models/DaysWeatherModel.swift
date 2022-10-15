//
//  DaysWeatherModels.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/14.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct DaysWeatherData: Codable {
    let response: DaysResponse
}

// MARK: - Response
struct DaysResponse: Codable {
    let header: DaysHeader
    let body: DaysBody
}

// MARK: - Body
struct DaysBody: Codable {
    let dataType: String
    let items: DaysWeatherItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct DaysWeatherItems: Codable {
    let item: [DaysWeatherItem]
}

// MARK: - Item
struct DaysWeatherItem: Codable {
    let taMin3, taMax3: Int
    let taMin4: Int
    let taMax4: Int
    let taMin5, taMax5: Int
    let taMin6: Int
    let taMax6: Int
    let taMin7, taMax7: Int
    let taMin8: Int
    let taMax8: Int
    let taMin9, taMax9: Int
    let taMin10: Int
    let taMax10: Int

//    enum CodingKeys: String, CodingKey {
//        case regID = "regId"
//        case taMin3, taMax3, taMin4, taMax4, taMin5, taMax5, taMin6, taMax6, taMin7, taMax7, taMin8, taMax8, taMin9, taMax9, taMin10, taMax10
//    }
}

// MARK: - Header
struct DaysHeader: Codable {
    let resultCode, resultMsg: String
}

struct DaysWeatherModel {
    let day: Int
    let high: Int
    let low: Int
}
