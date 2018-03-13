//
//  APIManger.swift
//  WeatherReport
//
//  Created by Dilshad on 10/03/18.
//  Copyright © 2018 Dilshad. All rights reserved.
//

import UIKit

typealias completionBlock = (_ response: [String: Any], _ isSucess: Bool) -> Void

class APIManger {
    
    static let shared = APIManger()
    
    private func postRequest(withUrl urlString: String, parameters param:[String: Any]?, httpType: String, completion: @escaping completionBlock) {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = httpType
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            do {
                
                guard data != nil else {
                    completion([String: Any](), false)
                    return
                }

                let response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                completion(response!, true)
                
            } catch {
                completion(error as! [String : Any], false)
            }
        })
        dataTask.resume()
    }
    
    func getWeatherList(withCountryName countryName: String, completionHandler: @escaping completionBlock) {
        
        
        let apiUrl = Constants.getWeatherDetailsUrl(countryName: countryName)
        self.postRequest(withUrl: apiUrl, parameters: nil, httpType: httpMethodType.get.rawValue) { (response, status) in
            completionHandler(response, status)
        }
    }
}
