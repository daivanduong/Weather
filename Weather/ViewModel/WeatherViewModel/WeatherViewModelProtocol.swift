//
//  WeatherViewModelProtocol.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import Foundation
protocol WeatherViewModelProtocol {
    var reloadUI: (() -> Void )? { get set }
    func callAPI()
    func getNameCity() -> String
    func getTemp_c() -> Double
    func getLinkIcon() -> String
    // collectionView
    var numberOfSections: Int { get }
    func numberOfCellsInSection(sesion: Int) -> Int
    func getTimeForCell(index: IndexPath) -> String
    func getUrlImageForCell(index: IndexPath) -> String
    func getTempForCell(index: IndexPath) -> Double
    // tableView
    
    func numberOfRowsInSection(sesion: Int) -> Int
    func getDayForRows(index: IndexPath) -> String
    func getUrlImageForRows(index: IndexPath) -> String
    func getTempMinForRows(index: IndexPath) -> Double
    func getTempMaxForRows(index: IndexPath) -> Double
    
}
