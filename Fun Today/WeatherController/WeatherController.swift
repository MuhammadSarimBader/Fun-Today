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
import CoreLocation

let KWeatherLocation:String = "location"
let KWeatherForecast:String = "forecast"
let KWeatherCurrent:String = "current"

let KForcastCell:String = "ForcastCell"


class WeatherController: UIViewController {
    
    let locManager = CLLocationManager()
    
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
        
        
//        let locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    // MARK: - SelfFunctions
    
    
    func getWeather(location:CLLocationCoordinate2D)  {
     
        WebService().getWeather(location: location) { (json) in
            let weatherData = json as! Dictionary<String, Any>
            let location = weatherData[KWeatherLocation] as! Dictionary<String, Any>
            let forecast = weatherData[KWeatherForecast] as! Dictionary<String, Any>
            let current = weatherData[KWeatherCurrent] as! Dictionary<String, Any>
            
            self.weatherView.set(location: location)
            self.weatherView.set(current: current)
            self.set(forecast: forecast)
        }
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
            
            
            let dayDate = eachData["date"] as! String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            let date = dateFormatter.date(from:dayDate)!
            
            dateFormatter.dateFormat = "EE"
            let dayInWeek = dateFormatter.string(from: date)
            dayDic["dayName"] = dayInWeek

            collectionDataArr.append(dayDic)
        }
        
        collectionViewForcast.reloadData()
    }
    

    
    // MARK: - IBActions

    @IBAction func onPopRestaurant(_ sender: Any) {
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
 
    
    

}

extension WeatherController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            if let currentLocation = locManager.location{
                self.getWeather(location: currentLocation.coordinate)
            }
        }
        
        
    }
}

extension WeatherController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KForcastCell, for: indexPath) as! ForcastCell
        
        let day = collectionDataArr[indexPath.row]
        
        
        cell.lblDay.text = day["dayName"]
        cell.lblMinDeg.text = day["mintemp_c"]
        cell.lblMaxDeg.text = day["maxtemp_c"]
        
        if let weatherIcon = day["icon"] {
            //self.set(imageView: cell.imgViewWeather, UrlS: weatherIcon)
            cell.imgViewWeather.setImage(urlS: weatherIcon)
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
