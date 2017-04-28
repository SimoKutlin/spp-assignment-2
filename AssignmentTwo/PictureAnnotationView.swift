//
//  PictureAnnotation.swift
//  AssignmentTwo
//
//  Created by admin on 28.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import MapKit
import UIKit

class PictureAnnotationView :  MKPinAnnotationView  {
    
       
    var calloutView: PictureCalloutView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // show callout if annotiation is selected, else remove
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.calloutView?.removeFromSuperview()
            
            let calloutView = PictureCalloutView(withImageUrl: photoData.thumbnailUrl)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
        } else {
            guard let calloutView = calloutView else { return }
            
            calloutView.removeFromSuperview()
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) { return hitView }
        
        if let calloutView = calloutView {
            let pointInCalloutView = convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }
        
        return nil
}
}
