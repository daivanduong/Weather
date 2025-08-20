//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import Foundation

class WeatherViewModel: WeatherViewModelProtocol {
    
    private var dataWeatherApi: WeatherApi?
    
    var reloadUI: (() -> ())?
    
    
//    func callAPI() {
//        let url = URL(string: "https://itunes.apple.com/search?term=Star%20Wars")
//        URLSession.shared.dataTask(with: url!) { [weak self] data, response , error in
//            if let data = data {
//                let movielData = try? JSONDecoder().decode(MovieAPI.self, from: data)
//                if movielData != nil {
//                    self?.movie = movielData
//                }
//            }
//        } .resume()
//    }
    
    func callAPI() {
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=df3d55c0b40341efb1e135746251808&q=phu tho&days=5")!
        URLSession.shared.dataTask(with: url) { [weak self] data, response , error in
            if let data = data {
                let dataApi = try! JSONDecoder().decode(WeatherApi.self, from: data)
                print(dataApi.location?.name)
                self?.dataWeatherApi = dataApi
                print(self?.dataWeatherApi?.location?.name)
                self?.reloadUI?()
               
            }
        } .resume()
    }
    
    func getNameCity() -> String {
        print(self.dataWeatherApi?.location?.name)
        return self.dataWeatherApi?.location?.name ?? ""
    }
    
    func getTemp_c() -> Double {
        return self.dataWeatherApi?.current?.temp_c ?? 0
    }
    
    func getLinkIcon() -> String {
        let url = dataWeatherApi?.current?.condition?.icon
        return "https:\(url ?? "")"
    }
    func getNameCity(indexPath: IndexPath) -> String {
        return self.dataWeatherApi?.location?.name ?? ""
    }
    func getTemp(indexPath: IndexPath) -> Double {
        return self.dataWeatherApi?.current?.temp_c ?? 0
    }
}
