//
//  WeatherController.swift
//  Fun Today
//
//  Created by Apple on 3/4/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import UIKit
import Alamofire

let KWeatherLocation:String = "location"
let KWeatherForecast:String = "forecast"
let KWeatherCurrent:String = "current"

let KForcastCell:String = "ForcastCell"


class WeatherController: UIViewController {
    
    @IBOutlet weak var collectionViewForcast: UICollectionView!{
        didSet{
            self.collectionViewForcast.delegate = self
            self.collectionViewForcast.dataSource = self
            
            self.collectionViewForcast.register(UINib.init(nibName: KForcastCell, bundle: .main), forCellWithReuseIdentifier: KForcastCell)
        }
    }
    
    
    
    var location: Dictionary<String, Any>?
    var forecast: Dictionary<String, Any>?
    var current: Dictionary<String, Any>?
    
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
                self.location = weatherData[KWeatherLocation] as! Dictionary<String, Any>
                self.forecast = weatherData[KWeatherForecast] as! Dictionary<String, Any>
                self.current = weatherData[KWeatherCurrent] as! Dictionary<String, Any>

            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
        
        
        
        
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KForcastCell, for: indexPath)
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
