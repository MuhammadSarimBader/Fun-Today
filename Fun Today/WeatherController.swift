//
//  WeatherController.swift
//  Fun Today
//
//  Created by Apple on 3/4/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


let KWeatherLocation:String = "location"
let KWeatherForecast:String = "forecast"
let KWeatherCurrent:String = "current"

let KForcastCell:String = "ForcastCell"


class WeatherController: UIViewController {
    
   
    @IBOutlet weak var weatherView: WeatherCurrentView!
    @IBOutlet weak var collectionViewForcast: UICollectionView!{
        didSet{
            self.collectionViewForcast.delegate = self
            self.collectionViewForcast.dataSource = self
            
            self.collectionViewForcast.register(UINib.init(nibName: KForcastCell, bundle: .main), forCellWithReuseIdentifier: KForcastCell)
        }
    }
    
   
    var collectionDataArr = Array<Dictionary<String, String>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Alamofire.request("https://api.apixu.com/v1/forecast.json?key=fa029dec276a493e99285815190403&q=Dubai&days=5").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
               // print("JSON: \(json)") // serialized json response
                let weatherData = json as! Dictionary<String, Any>
                let location = weatherData[KWeatherLocation] as! Dictionary<String, Any>
                let forecast = weatherData[KWeatherForecast] as! Dictionary<String, Any>
                let current = weatherData[KWeatherCurrent] as! Dictionary<String, Any>
                
                self.set(location: location)
                self.set(current: current)
                self.set(forecast: forecast)
            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
    }
    
    // MARK: - SelfFunctions
    
    func set(location: Dictionary<String, Any>) {
        weatherView.lblCity.text = location["name"] as? String
    }
    
    func set(forecast: Dictionary<String, Any>) {
       let forecastData = forecast["forecastday"] as! Array<Dictionary<String, Any>>
        for eachData in forecastData {
            
            var dayDic = Dictionary<String, String>()
            
            let day = eachData["day"] as! Dictionary<String, Any>
            
            let minTempC : CGFloat = day["mintemp_c"] as? CGFloat ?? 0
            let minTempS = "\(minTempC)"
            dayDic["mintemp_c"] = minTempS
            
            let maxTempC : CGFloat = day["maxtemp_c"] as? CGFloat ?? 0
            let maxTempS = "\(maxTempC)"
            dayDic["maxtemp_c"] = maxTempS

            if let condition = day["condition"] as? Dictionary<String, Any>{
                
                let imageUrl = condition["icon"] as? String
                let stripImageUrl = String.init(format: "https:%@", imageUrl!)
                dayDic["icon"] = stripImageUrl
            }
            
            collectionDataArr.append(dayDic)
        }
        
        collectionViewForcast.reloadData()
    }
    
    func set(imageView: UIImageView, UrlS:String) {
        Alamofire.request(UrlS).responseImage { response in
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
    
    func set(current: Dictionary<String, Any>) {
        //Setting weather current icon and about
        if let condition = current["condition"] as? Dictionary<String, Any>{
            weatherView.lblAbout.text = condition["text"] as? String
            let imageUrl = condition["icon"] as? String
            //var stripImageUrl: String = String((imageUrl?.dropFirst(2))!)
            let stripImageUrl = String.init(format: "https:%@", imageUrl!)
            self.set(imageView: self.weatherView.imgViewWeather, UrlS: stripImageUrl)
            
            //            Alamofire.request(stripImageUrl).responseImage { response in
//                if let image = response.result.value {
//                    self.weatherView.imgViewWeather.image = image
//                }
//            }
        }
        //Setting current day
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        
        weatherView.lblDay.text = dayInWeek
        //
        
        let tempC : Int = current["temp_c"] as? Int ?? 0
        let tempS = String(tempC)
        weatherView.lblDegreeVal.text = tempS
        
        let precip_in : Int = current["precip_in"] as? Int ?? 0
        let precip_inS = String(precip_in)
        weatherView.lblPrecipitation.text = precip_inS
        
        let humidity : Int = current["humidity"] as? Int ?? 0
        let humidityS = String(humidity)
        weatherView.lblHumidity.text = humidityS
        
        let wind_kph : CGFloat = current["wind_kph"] as? CGFloat ?? 0
        let wind_kphS = "\(wind_kph)"
        weatherView.lblWind.text = wind_kphS
        
    }
    
    // MARK: - IBActions

    @IBAction func onPopRestaurant(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension WeatherController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KForcastCell, for: indexPath) as! ForcastCell
        
        let day = collectionDataArr[indexPath.row]
        
        
        cell.lblDay.text = "SAT"
        cell.lblMinDeg.text = day["mintemp_c"]
        cell.lblMaxDeg.text = day["maxtemp_c"]
        
        if let weatherIcon = day["icon"] {
            self.set(imageView: cell.imgViewWeather, UrlS: weatherIcon)
        }
        
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let cellWidth = 80
//        let cellCount = 5
//        let cellSpacing = 1
//        let collectionViewWidth = UIScreen.main.bounds.size.width
//
//        let totalCellWidth = cellWidth * cellCount
//        let totalSpacingWidth = cellSpacing * (cellCount - 1)
//
//        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
   
    
    
}
