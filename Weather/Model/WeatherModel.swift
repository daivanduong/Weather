//
//  WeatherModel.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import Foundation
class WeatherApi: Codable {
    var location: Location?
    var current: Current?
    var forecast: Forecast?
    
    
}

class Location: Codable {
    var name: String?
    var country: String?
    var localtime: String?
}

class Current: Codable {
    var last_updated: String?
    var temp_c: Double?
    var is_day: Int?
    var condition: Condition?
    
}

class Condition: Codable {
    var text: String?
    var icon : String?
    var code : Int?
}

class Forecast: Codable {
    var forecastday: [Forecastday]?
}

class Forecastday: Codable {
    var date: String?
    var day: Day?
    var uv: Double?
    var astro: Astro?
    var hour: [Hour]?
}

class Day: Codable {
    var maxtemp_c: Double?
    var mintemp_c: Double?
    var daily_chance_of_rain: Int?
    var condition: Condition?
}
class Astro: Codable {
    var sunrise: String?
    var sunset: String?
}

class Hour: Codable {
    var time: String?
    var temp_c: Double?
    var is_day: Int?
    var condition: Condition?
    var humidity: Int?
    
}

