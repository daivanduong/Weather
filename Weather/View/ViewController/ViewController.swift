//
//  ViewController.swift
//  Weather
//
//  Created by Đại Dương on 19/08/2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    var viewModel: WeatherViewModelProtocol = WeatherViewModel()
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var lbCityName: UILabel!
    
    @IBOutlet weak var imgName: UIImageView!
    
    @IBOutlet weak var lbTemp: UILabel!
    
    @IBOutlet weak var tbWeatherViewHour: UITableView!
    
    @IBOutlet weak var collectionViewWeatherInHour: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBackgroundView()
        setupLbCityName()
        setupLbTemp()
        viewModel.callAPI()
        viewModel.reloadUI = { [weak self] in guard let self = self else { return }
            self.lbCityName.text = "T.\(self.viewModel.getNameCity())"
            self.imgName.sd_setImage(with: URL(string: "\(viewModel.getLinkIcon())"), placeholderImage: UIImage(named: "placeholder.png"))
            self.lbTemp.text = "\(self.viewModel.getTemp_c())°"
            setupCollectionView()
            setupTableView()
        }
       
    }
    
    func setupBackgroundView(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemGray.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
        viewBackground.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupLbCityName(){
        lbCityName.font = .systemFont(ofSize: 40, weight: .medium)
        lbCityName.textColor = .white
    }
    
    func setupLbTemp(){
        lbTemp.font = .systemFont(ofSize: 50, weight: .medium)
        lbTemp.textColor = .white
    }
    
    func setupCollectionView() {
        collectionViewWeatherInHour.delegate = self
        collectionViewWeatherInHour.dataSource = self
        collectionViewWeatherInHour.backgroundColor = .clear
        let nib = UINib(nibName: "WeatherHourCell", bundle: nil)
        collectionViewWeatherInHour.register(nib, forCellWithReuseIdentifier: "weatherHourCell")
        collectionViewWeatherInHour.reloadData()
    }
    
    func setupTableView() {
        tbWeatherViewHour.delegate = self
        tbWeatherViewHour.dataSource = self
        tbWeatherViewHour.backgroundColor = .clear
        let nib = UINib(nibName: "WeatherVCTableViewCell", bundle: nil)
        tbWeatherViewHour.register(nib, forCellReuseIdentifier: "weatherVCTableViewCell")
        tbWeatherViewHour.reloadData()
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCellsInSection(sesion: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherHourCell", for: indexPath) as! WeatherHourCell
        cell.lbHourInDay.text = viewModel.getTimeForCell(index: indexPath)
        cell.lbHourInDay.textColor = .white
        cell.iconWeatherInHour.sd_setImage(with: URL(string: "\(viewModel.getUrlImageForCell(index: indexPath ))"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.lbTempInHour.text = "\(viewModel.getTempForCell(index: indexPath))"
        cell.lbTempInHour.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(sesion: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherVCTableViewCell") as! WeatherVCTableViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.lbTime.text = viewModel.getDayForRows(index: indexPath)
        cell.lbTime.textColor = .white
        cell.imgIcon.sd_setImage(with: URL(string: "\(viewModel.getUrlImageForRows(index: indexPath))"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.lbTemp.text = " \(viewModel.getTempMinForRows(index: indexPath))° - \(viewModel.getTempMaxForRows(index: indexPath))°"
        cell.lbTemp.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "weatherVC") as! WeatherVC
//        let vm = DetailViewModel(movie: viewModel.getDataItemDetail(indexPath: indexPath))
//        vc.viewModel = vm
        navigationController?.pushViewController(vc, animated: true)
    }
}
