//
//  MapViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/27/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var currentUserID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        self.showCurrentLocationonMap()
    }
    
//    func showCurrentLocationonMap() {
//        let
//        cameraposition  = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!  , longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 100)
//        let  mapviewposition = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), camera: cameraposition)
//        mapviewposition.settings.myLocationButton = true
//        mapviewposition.isMyLocationEnabled = true
//
//        let marker = GMSMarker()
//        marker.position = cameraposition.target
//        marker.snippet = "Current Location"
//        marker.appearAnimation = GMSMarkerAnimation.pop
//        marker.map = mapviewposition
//        self.mapView.addSubview(mapviewposition)
//
//    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
//        self.locationManager.startUpdatingLocation()
    }

}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if let lastLocation = locations.last {
            let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
            let message = Message.init(type: .location, content: coordinate, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), width: 0, height: 0, isRead: false)
            Message.send(message: message, toID: self.currentUserID!, completion: {(_) in
                print(coordinate)
            })
        }
    }
}
