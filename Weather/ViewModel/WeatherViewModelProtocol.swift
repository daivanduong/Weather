//
//  WeatherViewModelProtocol.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import Foundation
protocol WeatherViewModelProtocol {
    var reloadUI: (() -> ())? { get set }
    func callAPI()
    func getNameCity() -> String
    func getTemp_c() -> Double
    func getLinkIcon() -> String
    
    func getNameCity(indexPath: IndexPath) -> String
    func getTemp(indexPath: IndexPath)-> Double
}
