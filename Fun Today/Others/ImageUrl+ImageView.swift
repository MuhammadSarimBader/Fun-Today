//
//  ImageUrl+ImageView.swift
//  Fun Today
//
//  Created by Apple on 3/4/19.
//  Copyright © 2019 AYM. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView{
    func setImage(urlS:String) {
        Alamofire.request(urlS).responseImage { response in
            if let image = response.result.value {
                self.image = image
            }
        }
    }
}
