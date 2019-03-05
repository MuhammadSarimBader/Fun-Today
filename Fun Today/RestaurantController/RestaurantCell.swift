//
//  RestaurantCell.swift
//  Fun Today
//
//  Created by Apple on 3/5/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Cosmos

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var lblReviewsCount: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var imgViewRestaurant: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(restaurant:Dictionary<String, String>) {
        print(restaurant)
        
        lblName.text = restaurant["name"]
        
        let rating = restaurant["rating"]
        lblRating.text = restaurant["rating"]
        
        let ratingFloat = (rating! as NSString).doubleValue
        ratingView.rating = ratingFloat
        
        let reviewCount = restaurant["user_ratings_total"]
        lblReviewsCount.text = reviewCount
        
        btnType.setTitle("Labenese", for: .normal)
        
        if let photoRefUrlS = restaurant["photo_reference"] {
            let imageUrl = URL.init(string: photoRefUrlS)
            imgViewRestaurant.af_setImage(withURL: imageUrl!, placeholderImage: nil)
        }

        self.set(addressUrlS: restaurant["place_reference_url"]!)
    }
    
    func set(addressUrlS:String) {
        
        Alamofire.request(addressUrlS).responseJSON { response in
            
            if let json = response.result.value {
                let restaurantData = json as! Dictionary<String, Any>
                if (restaurantData["status"] as! String == "OK"){
                    let results = restaurantData["result"] as! Dictionary<String, Any>
                    let addressComponent = results["address_components"] as! Array<Dictionary<String, Any>>
                    let name = addressComponent.first?["short_name"] as! String
                    self.btnLocation.setTitle(name, for: .normal)
                }
            }
        }
    }
    
}
