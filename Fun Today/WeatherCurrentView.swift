//
//  WeatherCurrentView.swift
//  Fun Today
//
//  Created by Apple on 3/4/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import UIKit

class WeatherCurrentView: UIView {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblDegreeVal: UILabel!
    @IBOutlet weak var lblPrecipitation: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
     @IBOutlet weak var imgViewWeather: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    // MARK: - IBActions
    
    @IBAction func onCentigrade(_ sender: Any) {
        
    }
    @IBAction func onFahrenheit(_ sender: Any) {
        
    }
    
    
}
