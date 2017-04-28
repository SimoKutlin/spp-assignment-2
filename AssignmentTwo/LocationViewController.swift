//
//  LocationViewController.swift
//  AssignmentTwo
//
//  Created by admin on 27.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var photoData: Photo? {
        didSet {
            locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            fetchLocation()
        }
    }
    var pictureLocation: Location!
    
    private var locationManager: CLLocationManager!
    
    private func fetchLocation() {
        NetworkManager.shared.requestLocation(for: (photoData?.identifier)!) { (response, error) in
            if let location = response?.objects {
                self.pictureLocation = location[0]
                if (self.pictureLocation.latitude != nil && self.pictureLocation.longitude != nil) {
                    let annotation = PictureAnnotation(CLLocationCoordinate2D(latitude: self.pictureLocation.latitude, longitude: self.pictureLocation.longitude))
                    
                    self.mapView.addAnnotation(annotation)
                    
                    
                    self.mapView.showsUserLocation = true
                    let picLoc: CLLocation = CLLocation(latitude: annotation.coordinates.latitude, longitude: annotation.coordinates.longitude)
                    let userLoc: CLLocation = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                    let distance: Double = (userLoc.distance(from: picLoc) / 1000)
                    self.distanceLabel.text = "Distance from your location: \(String(format: "%.2f", distance)) km"
                    
                    //https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
                    
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.distanceLabel.text = "Sry! API returned no location"
    }
    
}
