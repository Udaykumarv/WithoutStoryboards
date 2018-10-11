//
//  ViewController.swift
//  WeatherReport
//
//  Created by Dilshad on 09/03/18.
//  Copyright © 2018 Dilshad. All rights reserved.
//

import UIKit

private let degreeSymbol = "\u{00B0}" + "C"

class WeatherReportViewController: UIViewController {

    var weatherInfo: WeatherInfo?
    var countryNamesList = ["London", "Hurzuf", "Holubynka", "Karow", "Vavibet", "Kathmandu", "Birim", "Vinogradovo", "Alupka", "Tyuzler", "Yurevichi", "Sri Lanka" ]
    
    let countryNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "CountryName"
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0" + degreeSymbol
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView =  UIActivityIndicatorView(frame: UIScreen.main.bounds)
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        addLabelAndButton()
        addActivityIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Helper methods -
extension WeatherReportViewController {
    private func addLabelAndButton() {
        
        // creating Button
        let pickCityButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("Pick City", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.addTarget(self, action: #selector(pickCityButtonTapped(sender:)), for: .touchUpInside)
            return button
        }()
        
        // Adding
        self.view.addSubview(countryNameLabel)
        self.view.addSubview(temperatureLabel)
        self.view.addSubview(pickCityButton)
        
        //Adding Constraints
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", metricsDict: nil, views: countryNameLabel)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", metricsDict: nil, views: temperatureLabel)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", metricsDict: nil, views: pickCityButton)

        self.view.addConstraintsWithFormat(format: "V:|-70-[v0(30)]-10-[v1(30)]-10-[v2(40)]", metricsDict: nil, views: countryNameLabel, temperatureLabel, pickCityButton)
    }
    
    private func addActivityIndicator() {
        
        self.view.addSubview(activityIndicator)
        
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", metricsDict: nil, views: activityIndicator)
        self.view.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", metricsDict: nil, views: activityIndicator)
    }
}

//MARK: - API Fetching related methods -
extension WeatherReportViewController {
    
    private func fetchWeatherDetails(countryName: String) {
        
        activityIndicator.startAnimating()
        APIManger.shared.getWeatherList(withCountryName: countryName) { (response, status) in
            if status == true {
                print(response)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.weatherInfo = WeatherInfo(params: response)
                    
                    guard self.weatherInfo != nil else {
                        return
                    }

                    self.temperatureLabel.text = self.weatherInfo!.temperature + degreeSymbol
                    self.countryNameLabel.text = self.weatherInfo?.countryName
                }
            }
        }
    }
}


//MARK: - Button action methods -
extension WeatherReportViewController {
    
    @objc func pickCityButtonTapped(sender: Any) {
        
        ActionSheetViewController.showActionSheet(withDataSource: countryNamesList, atCurrentVC: self, tableViewHeight: 50, headerText: "Country Names", footerText: nil)
    }
}


//MARK: - ActionSheetViewControllerDelegate methods -

extension WeatherReportViewController: ActionSheetViewControllerDelegate {
    
    func actionSheet(_ actionSheetVC: ActionSheetViewController, didSelectRowAt indexPathRow: Int) {
        print(indexPathRow)
        
        fetchWeatherDetails(countryName: countryNamesList[indexPathRow])
        
    }
}

