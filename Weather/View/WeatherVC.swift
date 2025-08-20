//
//  WeatherVC.swift
//  Weather
//
//  Created by Đại Dương on 20/08/2025.
//

import UIKit

class Phone: Codable {
    var name = ""
    var price = ""
    init(name: String = "", price: String = "") {
        self.name = name
        self.price = price
    }
}


class WeatherVC: UIViewController {
    
    var arrPhone = [Phone]()
    
    var viewModel: WeatherViewModelProtocol = WeatherViewModel()

    @IBOutlet weak var tableViewWeatherCurren: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewModel.callAPI()
        bindata()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tableViewWeatherCurren.delegate = self
        tableViewWeatherCurren.dataSource = self
        let nib = UINib(nibName: "WeatherVCTableViewCell", bundle: nil)
        tableViewWeatherCurren.register(nib, forCellReuseIdentifier: "weatherVCTableViewCell")
        tableViewWeatherCurren.reloadData()
    }
    
    func bindata() {
        let a = Phone(name: "iphone", price: "100")
        let b = Phone(name: "samsung", price: "200")
        arrPhone.append(a)
        arrPhone.append(b)
        tableViewWeatherCurren.reloadData()
    }


}


extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPhone.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherVCTableViewCell") as! WeatherVCTableViewCell
        let data = arrPhone[indexPath.row]
        cell.lbTemp.text = data.name
        cell.lbCityName.text = data.price
        return cell
    }
}
