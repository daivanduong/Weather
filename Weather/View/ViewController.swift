//
//  ViewController.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel: WeatherViewModelProtocol = WeatherViewModel()
    var dataWeatherApi: WeatherApi!
    
    @IBOutlet weak var lbCityName: UILabel!
    
    @IBOutlet weak var imgName: UIImageView!
    
    @IBOutlet weak var lbTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=df3d55c0b40341efb1e135746251808&q=phu tho&days=5")!
        URLSession.shared.dataTask(with: url) { [weak self] data, response , error in
            if let data = data {
                let dataApi = try! JSONDecoder().decode(WeatherApi.self, from: data)
                print(dataApi.location?.name as Any)
                self?.dataWeatherApi = dataApi
                self?.lbCityName.text = dataApi.location!.name
//                print(self?.dataWeatherApi?.location?.name)
//                self?.reloadUI?()
               
            }
        } .resume()
        
        
        //lbCityName.text = dataWeatherApi.location!.name ?? ""
       
        
        //lbTemp.text = "\(dataWeatherApi.current?.temp_c)"
       
    }
    
    
    
    func setupView() {
        viewModel.callAPI()
        viewModel.reloadUI
    }


}
