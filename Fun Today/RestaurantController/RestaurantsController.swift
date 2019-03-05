//
//  RestaurantsController.swift
//  Fun Today
//
//  Created by Apple on 3/5/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


let KRestaurantCell:String = "RestaurantCell"
let KGoogleAPIKey:String = "AIzaSyDensy8hUjbfXU0xQkiCdjr64kVLsCaWNM"

class RestaurantsController: UIViewController {

    @IBOutlet weak var tableViewRestaurant: UITableView!{
        didSet{
            self.tableViewRestaurant.delegate = self
            self.tableViewRestaurant.dataSource = self
            self.tableViewRestaurant.register(UINib.init(nibName: KRestaurantCell, bundle: .main), forCellReuseIdentifier: KRestaurantCell)
        }
    }
    
    let locManager = CLLocationManager()
    var tableDataArr = Array<Dictionary<String, String>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()

//        if let location = locManager.location {
//           // self.getRestaurant(location: location.coordinate)
//        }
        
    }
    
    
    
    func getRestaurant(location:CLLocationCoordinate2D)  {
        
        WebService().getRestaurant(location: location) { (json) in
            let restaurantData = json as! Dictionary<String, Any>
            if (restaurantData["status"] as! String == "OK"){
                let results = restaurantData["results"] as! Array<Dictionary<String, Any>>
                self.set(restaurants: results)
            }
        }
    }
    
    
    // MARK: - SelfFunctions
    func set(restaurants: Array<Dictionary<String, Any>>) {
        for restaurant in restaurants {
            
            var restaurantDic = Dictionary<String, String>()
            
            let name = restaurant["name"] as! String
            restaurantDic["name"] = name
            
            let userReviewCount : Int = restaurant["user_ratings_total"] as? Int ?? 0
            let userReviewCountS = String(userReviewCount)
            restaurantDic["user_ratings_total"] = userReviewCountS
            
            let usersRating : CGFloat = restaurant["rating"] as? CGFloat ?? 0
            let usersRatingS = "\(usersRating)"
            restaurantDic["rating"] = usersRatingS
            
            if let photos = restaurant["photos"] as? Array<Dictionary<String, Any>> {
                if (photos.count > 0) {
                    let photoRefID = photos[0]["photo_reference"] as! String
                    let photoUrlS = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=\(photoRefID)&key=\(KGoogleAPIKey)"
                
                    restaurantDic["photo_reference"] = photoUrlS
                }
            }
            
        
            let placeRefID = restaurant["place_id"] as! String
            let placeUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeRefID)&key=\(KGoogleAPIKey)"
            restaurantDic["place_reference_url"] = placeUrl
            
            self.tableDataArr.append(restaurantDic)
        }
        
        tableViewRestaurant.reloadData()
    }
    
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension RestaurantsController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            if let currentLocation = locManager.location{
                self.getRestaurant(location: currentLocation.coordinate)
            }
        }
        
        
    }
}




extension RestaurantsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KRestaurantCell, for: indexPath) as! RestaurantCell
        let restaurant = tableDataArr[indexPath.row]
        cell.set(restaurant: restaurant)
        
        
        return cell
    }
    
    
}
