//
//  Extensions.swift
//  WeatherReport
//
//  Created by Dilshad on 10/03/18.
//  Copyright © 2018 Dilshad. All rights reserved.
//

import UIKit

//MARK: - extensions -
extension UIView {
    
    /**
     * Below method is used to add auto layouts programmatically for subviews.
     */
    func addConstraintsWithFormat(format: String, metricsDict: [String: Any]?, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {//.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metricsDict, views: viewsDictionary))
    }
}
