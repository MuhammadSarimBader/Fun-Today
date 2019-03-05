//
//  WebService.swift
//  Fun Today
//
//  Created by Apple on 3/4/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class WebService {
    
    func request(urlS:String, Success:@escaping (Any)->Void) {
        Alamofire.request(urlS).responseJSON { response in
            
            if let json = response.result.value {
                Success(json)
            }
        }
    }
    
    public func getWeather(location:CLLocationCoordinate2D, Success:@escaping (Any)->Void)  {
        
        let latLon = "\(location.latitude),\(location.longitude)"
        let urlStr = "https://api.apixu.com/v1/forecast.json?key=fa029dec276a493e99285815190403&q=\(latLon)&days=5"
        
        request(urlS: urlStr) { (json) in
            Success(json)
        }
    }
    
    public func getRestaurant(location:CLLocationCoordinate2D, Success:@escaping (Any)->Void)  {
        let latLon = "\(location.latitude),\(location.longitude)"
        
        let urlStr = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLon)&rankby=distance&type=restaurant&key=AIzaSyDensy8hUjbfXU0xQkiCdjr64kVLsCaWNM"
        
        request(urlS: urlStr) { (json) in
            Success(json)
        }
    }
}
