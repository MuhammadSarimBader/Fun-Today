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
    
    
    func requestModelSaveGameResultNew(parameters :Parameters, Success:@escaping (NSDictionary)->Void, Failure:@escaping (NSError)->Void) {
    }
    
    public func getWeather(location:CLLocationCoordinate2D, Success:@escaping (Any)->Void)  {
        
        let latLon = "\(location.latitude),\(location.longitude)"
        let weatherUrlStr = "https://api.apixu.com/v1/forecast.json?key=fa029dec276a493e99285815190403&q=\(latLon)&days=5"
        
        Alamofire.request(weatherUrlStr).responseJSON { response in
            
            // response serialization result
            
            if let json = response.result.value {
                // print("JSON: \(json)") // serialized json response
              Success(json)
            }
        }
    }
}
