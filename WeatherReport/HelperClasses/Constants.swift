//
//  Constants.swift
//  WeatherReport
//
//  Created by Dilshad on 10/03/18.
//  Copyright © 2018 Dilshad. All rights reserved.
//

enum httpMethodType: String {
    case post = "POST"
    case get = "GET"
}


class Constants {
    
    class func getWeatherDetailsUrl(countryName: String) -> String {
        let weatherDetailsURL = "http://api.openweathermap.org/data/2.5/weather?q="+countryName+"&appid=39b0d983bcc55f164edccf1b7f090867"

        return weatherDetailsURL
    }
}

