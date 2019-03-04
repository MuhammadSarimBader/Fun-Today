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

    func set(location: Dictionary<String, Any>) {
        self.lblCity.text = location["name"] as? String
    }
    
    func set(current: Dictionary<String, Any>) {
        //Setting weather current icon and about
        if let condition = current["condition"] as? Dictionary<String, Any>{
            self.lblAbout.text = condition["text"] as? String
            let imageUrl = condition["icon"] as? String
            //var stripImageUrl: String = String((imageUrl?.dropFirst(2))!)
            let stripImageUrl = String.init(format: "https:%@", imageUrl!)
            self.imgViewWeather.setImage(urlS: stripImageUrl)
        }
        //Setting current day
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        
        self.lblDay.text = dayInWeek
        //
        
        let tempC : Int = current["temp_c"] as? Int ?? 0
        let tempS = String(tempC)
        self.lblDegreeVal.text = tempS
        
        let precip_in : Int = current["precip_in"] as? Int ?? 0
        let precip_inS = String(precip_in)
        self.lblPrecipitation.text = precip_inS
        
        let humidity : Int = current["humidity"] as? Int ?? 0
        let humidityS = String(humidity)
        self.lblHumidity.text = humidityS
        
        let wind_kph : CGFloat = current["wind_kph"] as? CGFloat ?? 0
        let wind_kphS = "\(wind_kph)"
        self.lblWind.text = wind_kphS
        
    }
    // MARK: - IBActions
    
    @IBAction func onCentigrade(_ sender: Any) {
        
    }
    @IBAction func onFahrenheit(_ sender: Any) {
        
    }
    
    
}
