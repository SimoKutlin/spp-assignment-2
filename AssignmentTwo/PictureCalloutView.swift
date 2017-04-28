//
//  PictureCalloutView.swift
//  AssignmentTwo
//
//  Created by admin on 28.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import UIKit
import MapKit

class PictureCalloutView :  MKPinAnnotationView  {
    
    var picture: UIImageView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(withImageUrl picUrl: String) {
        super.init()
        self.picture.image = UIImage(named: picUrl)
    }
    
}
