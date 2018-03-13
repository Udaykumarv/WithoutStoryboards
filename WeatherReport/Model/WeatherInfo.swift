//
//  WeatherInfo.swift
//  WeatherReport
//
//  Created by Dilshad on 10/03/18.
//  Copyright © 2018 Dilshad. All rights reserved.
//

import Foundation

struct WeatherInfo {
    
    var countryName = String()
    var temperature = String()
    var countryId = Int()
    
    init(params: [String : Any]) {
        
        self.countryName = (params["name"] as? String) ?? ""
        self.countryId = (params["id"] as? Int) ?? 0
        
        if let mainDict = params["main"] as? [String: Any] {
            self.temperature = String(describing: mainDict["temp"]!) 
        }
    }
}
