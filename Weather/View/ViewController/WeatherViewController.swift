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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lbCityName: UILabel!
    
    @IBOutlet weak var activityIndication: UIActivityIndicatorView!
    
    @IBOutlet weak var imgName: UIImageView!
    
    @IBOutlet weak var infoWeatherCurrent: UILabel!
    
    @IBOutlet weak var lbTemp: UILabel!
    
    @IBOutlet weak var tbWeatherViewHour: UITableView!
    
    @IBOutlet weak var collectionViewWeatherInHour: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBackgroundView()
        viewBackground.isHidden = true
        activityIndication.isHidden = false
        activityIndication.startAnimating()
        viewModel.callAPI()
        
        viewModel.reloadUI = { [weak self] in
            guard let self = self else { return }
            self.lbCityName.text = self.viewModel.getNameCity()
            self.imgName.sd_setImage(with: URL(string: "\(viewModel.getLinkIcon())"), placeholderImage: UIImage(named: "placeholder.png"))
            self.infoWeatherCurrent.text = self.viewModel.getInfoWeatherCurrent()
            self.lbTemp.text = "\(self.viewModel.getTemp_c())°"
            setupCollectionView()
            setupTableView()
            self.activityIndication.stopAnimating()
            self.activityIndication.isHidden = true
            self.collectionViewWeatherInHour.isHidden = false
            viewBackground.isHidden = false
        }
        setupUiSearchBar()
        setupLableView()
        setupGesture()
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
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
    
    func setupUiSearchBar() {
        searchBar.alpha = 0.5
        searchBar.searchBarStyle = .minimal   // bỏ viền mặc định
        searchBar.barTintColor = .clear       // màu nền ngoài
        searchBar.searchTextField.backgroundColor = UIColor(white: 0.95, alpha: 1) // nền ô nhập
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm ... ")
        
    }
    
    func setupGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(reloadApi))
        swipeGesture.cancelsTouchesInView = false
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        viewBackground.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
           searchBar.resignFirstResponder()
       }
    
    @objc private func reloadApi() {
        collectionViewWeatherInHour.isHidden = true
        activityIndication.startAnimating()
        activityIndication.isHidden = false
        viewModel.callAPI()
    }
    
    func setupLableView() {
        lbCityName.font = .systemFont(ofSize: 35, weight: .medium)
        lbCityName.textColor = .white
        
        infoWeatherCurrent.font = .systemFont(ofSize: 17, weight: .medium)
        infoWeatherCurrent.textColor = .white
        
        lbTemp.font = .systemFont(ofSize: 40, weight: .medium)
        lbTemp.textColor = .white
        
        imgName.contentMode = .scaleToFill
    }
    
    func setupCollectionView() {
        collectionViewWeatherInHour.delegate = self
        collectionViewWeatherInHour.dataSource = self
        collectionViewWeatherInHour.layer.borderWidth = 1
        collectionViewWeatherInHour.layer.borderColor = UIColor.gray.cgColor
        collectionViewWeatherInHour.layer.cornerRadius = 10
        collectionViewWeatherInHour.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        let nib = UINib(nibName: "WeatherHourCell", bundle: nil)
        collectionViewWeatherInHour.register(nib, forCellWithReuseIdentifier: "weatherHourCell")
        collectionViewWeatherInHour.reloadData()
    }
    
    func setupTableView() {
        tbWeatherViewHour.delegate = self
        tbWeatherViewHour.dataSource = self
        tbWeatherViewHour.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        tbWeatherViewHour.layer.borderWidth = 1
        tbWeatherViewHour.layer.borderColor = UIColor.gray.cgColor
        tbWeatherViewHour.layer.cornerRadius = 10
        let nib = UINib(nibName: "WeatherVCTableViewCell", bundle: nil)
        tbWeatherViewHour.register(nib, forCellReuseIdentifier: "weatherVCTableViewCell")
        tbWeatherViewHour.reloadData()
    }

}





//--------------- SEARCH BAR  -----------------------------------------//

extension ViewController: UISearchBarDelegate {
   
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            searchBar.alpha = 1.0
            searchBar.searchTextField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            searchBar.alpha = 0.5
            searchBar.searchTextField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let key = searchBar.text, !key.isEmpty else { return }
        viewModel.callAPIWithKey(key: key)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            searchBar.alpha = 0.5
            searchBar.searchTextField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }
}







//--------------- COLLECTION VIEW  -----------------------------------------//

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
        return CGSize(width: 70, height: 150)
    }
}





//--------------- TABLE VIEW -----------------------------------------//

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Dự báo 10 ngày "
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(20)
    }
    
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
        cell.selectionStyle = .none
        cell.lbTime.text = viewModel.getDayForRows(index: indexPath)
        cell.lbTime.textColor = .white
        cell.imgIcon.sd_setImage(with: URL(string: "\(viewModel.getUrlImageForRows(index: indexPath))"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.lbTemp.text = " \(viewModel.getTempMinForRows(index: indexPath))° - \(viewModel.getTempMaxForRows(index: indexPath))°"
        cell.lbTemp.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "detailWeatherInDayVC") as! DetailWeatherInDayVC
        let vm = DetailWeatherInDayModel(forecastday: viewModel.getDataWeatherInDay(index: indexPath))
        vc.viewModel = vm
        present(vc, animated: true)
    }
    
}
