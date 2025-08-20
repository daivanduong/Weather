//
//  ViewController.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel: WeatherViewModelProtocol = WeatherViewModel()
    
    @IBOutlet weak var lbCityName: UILabel!
    
    @IBOutlet weak var imgName: UIImageView!
    
    @IBOutlet weak var lbTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        lbCityName.text = viewModel.getNameCity()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbCityName.text = viewModel.getNameCity()
       
        
        lbTemp.text = "\(viewModel.getTemp_c())"
    }
    
    func setupView() {
        viewModel.callAPI()
        viewModel.reloadUI
    }


}
