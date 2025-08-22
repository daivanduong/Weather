//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import Foundation

class WeatherViewModel: WeatherViewModelProtocol {
   
    private var dataWeatherApi: WeatherApi?
    private var hourInDay: [Hour]?
    
    var reloadUI: (() -> Void )?
    
    func callAPI() {
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=517d3b9477634d7eb0b151418252008&q=Vinh phuc&days=5")!
        URLSession.shared.dataTask(with: url) { [weak self] data, response , error in
            if let data = data {
                let dataApi = try! JSONDecoder().decode(WeatherApi.self, from: data)
                self?.dataWeatherApi = dataApi
                self?.hourInDay = dataApi.forecast?.forecastday?.first?.hour
                //self?.forecastday = self?.dataWeatherApi as! [Forecastday]
                DispatchQueue.main.async {
                    self?.reloadUI?()
                }
            }
        }.resume()
    }
    
    func getNameCity() -> String {
        return self.dataWeatherApi?.location?.name ?? ""
    }
    
    func getTemp_c() -> Double {
        return self.dataWeatherApi?.current?.temp_c ?? 0
    }
    
    func getLinkIcon() -> String {
        let url = self.dataWeatherApi?.current?.condition?.icon
        return "https:\(url ?? "")"
    }
    
    
    // CollectionView
    
    func numberOfCellsInSection(sesion: Int) -> Int {
        
        return hourInDay?.count ?? 1
    }
    
    func getTimeForCell(index: IndexPath) -> String {
        let stringtime = hourInDay?[index.row].time
        let stringHour = getTextAfterSpace(stringtime ?? "")
        return  stringHour
    }
    
    func getUrlImageForCell(index: IndexPath) -> String {
        let url = "https:\(hourInDay?[index.row].condition?.icon ?? "")"
        return url
    }
    
    func getTempForCell(index: IndexPath) -> Double {
        return hourInDay?[index.row].temp_c ?? 0
    }
    
    func getTextAfterSpace(_ input: String) -> String {
        if let spaceIndex = input.firstIndex(of: " ") {
            return String(input[input.index(after: spaceIndex)...])
        }
        return input // nếu không có dấu cách thì trả về nguyên chuỗi
    }
    
    // TablleView
    
    var numberOfSections: Int {
        return  1
    }
    
    func numberOfRowsInSection(sesion: Int) -> Int {
        return dataWeatherApi?.forecast?.forecastday?.count ?? 1
    }
    
    func getDayForRows(index: IndexPath) -> String {
        let data = dataWeatherApi?.forecast?.forecastday?[index.row].date
        
        return getWeekday(from: dataWeatherApi?.forecast?.forecastday?[index.row].date ?? "") ?? "default value"
    }
    
    func getUrlImageForRows(index: IndexPath) -> String {
        let url = "https:\(dataWeatherApi?.forecast?.forecastday?[index.row].day?.condition?.icon ?? "")"
        return  url
    }
    
    func getTempMinForRows(index: IndexPath) -> Double {
        return dataWeatherApi?.forecast?.forecastday?[index.row].day?.mintemp_c ?? 0
    }
    
    func getTempMaxForRows(index: IndexPath) -> Double {
        return dataWeatherApi?.forecast?.forecastday?[index.row].day?.maxtemp_c ?? 0
    }
    
    
    func getWeekday(from dateString: String, inputFormat: String = "yyyy-MM-dd", locale: String = "vi_VN") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.locale = Locale(identifier: locale)
        
        // chuyển chuỗi thành Date
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        
        // đổi Date sang thứ
        formatter.dateFormat = "EEEE" // EEEE = tên thứ đầy đủ
        return formatter.string(from: date)
    }
    
    
    
    
}
