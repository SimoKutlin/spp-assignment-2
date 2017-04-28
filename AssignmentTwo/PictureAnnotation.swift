//
//  PictureAnnotation.swift
//  AssignmentTwo
//
//  Created by admin on 28.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import UIKit
import MapKit

class PictureAnnotation: NSObject, MKAnnotation {
    
    internal var coordinate: CLLocationCoordinate2D
    
    var coordinates: CLLocationCoordinate2D {
        return self.coordinate
    }
    
    init(_ coordinates: CLLocationCoordinate2D) {
        self.coordinate = coordinates
    }
}
