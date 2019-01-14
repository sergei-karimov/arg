//
//  ViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 18/12/2018.
//  Copyright © 2018 Sergei Karimov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var location: CLLocation!
    
//    @IBOutlet weak var plusBtnClicked: UITapGestureRecognize!
    @IBOutlet weak var mainImgBtn: UIImageView!
    @IBOutlet weak var excurtionImgBtn: UIImageView!
    @IBOutlet weak var myRouteImgBtn: UIImageView!
    @IBOutlet weak var cabnetImgBtn: UIImageView!
    
    var spanDelta = 0.77
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // 1. The ViewController is the delegate of the MKMapViewDelegate protocol
        mapView.delegate = self
        
        do {
            showImHere(mapView)
        } catch {
            NSLog(error as! String)
        }
    }
    
    func createDirection(_ sourceMapItem: MKMapItem, _ destinationMapItem: MKMapItem) -> MKDirections {
        // 7. The MKDirectionsRequest class is used to compute the route.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        return directions;
    }

    func drawDirection(_ directions: MKDirections) {
        // 8. The route will be drawn using a polyline as a overlay view on top of the map. The region is set so both locations will be visible
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }

    }
    
    // [sourceAnnotation, viaAnnotation, destinationAnnotation]
    func showAnnotation(_ annotations: [MKAnnotation]) {
        // 6. The annotations are displayed on the map
        self.mapView.showAnnotations(annotations, animated: true )
    }
    
    func prepareRoute() -> [MKAnnotation] {
        // 2. Set the latitude and longtitude of the locations
        let point_one = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let point_two = CLLocationCoordinate2D(latitude: 40.754011, longitude: -73.984472)
        let point_three = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        // 3. Create placemark objects containing the location's coordinates
        let onePlacemark = MKPlacemark(coordinate: point_one, addressDictionary: nil)
        let twoPlackmark = MKPlacemark(coordinate: point_two, addressDictionary: nil)
        let threePlacemark = MKPlacemark(coordinate: point_three, addressDictionary: nil)
        
        // 4. MKMapitems are used for routing. This class encapsulates information about a specific point on the map
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let viaMapItem = MKMapItem(placemark: viaPlackmark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5. Annotations are added which shows the name of the placemarks
        let oneAnnotation = MKPointAnnotation()
        oneAnnotation.title = "Times Square"
        
        if let location = onePlacemark.location {
            oneAnnotation.coordinate = location.coordinate
        }
        
        let twoAnnotation = MKPointAnnotation()
        twoAnnotation.title = "Via Building"
        
        if let location = twoPlackmark.location {
            twoAnnotation.coordinate = location.coordinate
        }
        
        let threeAnnotation = MKPointAnnotation()
        threeAnnotation.title = "Empire State Building"
        
        if let location = threePlacemark.location {
            threeAnnotation.coordinate = location.coordinate
        }
        
        return [oneAnnotation, twoAnnotation, threeAnnotation]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func showImHere(_ mapView: MKMapView) {
        let lastDelta = mapView.region.span

        var center = CLLocationCoordinate2D(latitude: 55.795183, longitude: 48.793128)
        center.latitude = mapView.userLocation.coordinate.latitude 
        center.longitude = mapView.userLocation.coordinate.longitude
        
        let span = MKCoordinateSpan(latitudeDelta: lastDelta.latitudeDelta, longitudeDelta: lastDelta.longitudeDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: Actions
    @IBAction func MapPlus(_ sender: Any) {
        let lastDelta = self.mapView.region.span
        let latDelta = lastDelta.latitudeDelta * spanDelta
        if latDelta <= 0 {
            return;
        }
        
        let lonDelta = lastDelta.longitudeDelta * spanDelta
        if lonDelta <= 0 {
            return;
        }
        
//        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: lastDelta, longitudeDelta: lastDelta))
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func MapMinus(_ sender: Any) {
        let lastDelta = self.mapView.region.span
        let latDelta = lastDelta.latitudeDelta / spanDelta
        if latDelta <= 0 {
            return;
        }
        
        let lonDelta = lastDelta.longitudeDelta / spanDelta
        if lonDelta <= 0 {
            return;
        }
        
        //        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: lastDelta, longitudeDelta: lastDelta))
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func MapIAmHere(_ sender: Any) {
        showImHere(self.mapView)
    }
}
