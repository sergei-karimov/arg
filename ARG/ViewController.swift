//
//  ViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 18/12/2018.
//  Copyright © 2018 Sergei Karimov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    let locationManager = CLLocationManager()
    var location: CLLocation!
    
//    @IBOutlet weak var plusBtnClicked: UITapGestureRecognize!
    @IBOutlet weak var mainImgBtn: UIImageView!
    @IBOutlet weak var excurtionImgBtn: UIImageView!
    @IBOutlet weak var myRouteImgBtn: UIImageView!
    @IBOutlet weak var cabnetImgBtn: UIImageView!
    
    var spanDelta = 0.77
    
    @IBOutlet weak var mapView: MKMapView!
    
    var poiworks: [POIwork] = []
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func prepareRoute(poiWorks: [POIwork]) -> [MKMapItem] {
        var res: [MKMapItem] = []
        for pw in poiworks {
            let poiPlaceMaker: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: pw.coordinate.latitude, longitude: pw.coordinate.longitude))
            let mapItem: MKMapItem = MKMapItem(placemark: poiPlaceMaker)
            res.append(mapItem)
        }
        
        return res
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoutePopupViewControllerSegue" {
            let popup = segue.destination as! RoutePopupViewController
            
            popup.onSave = onSave
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 55.795183, longitude: 48.793128)
        centerMapOnLocation(location: initialLocation)

        loadInitialData()
        mapView.addAnnotations(poiworks)
        
        showImHere(mapView)
    }
    
    func onSave(_ data: String) -> () {
        makeRoute()
    }

    func makeRoute() {
        let mapItems = prepareRoute(poiWorks: poiworks)
        let oneDirection = createDirection(mapItems[0], mapItems[1])
        drawDirection(oneDirection)
        let twoDirection = createDirection(mapItems[1], mapItems[2])
        drawDirection(twoDirection)
        let threeDirection = createDirection(mapItems[2], mapItems[3])
        drawDirection(threeDirection)
        let fourDirection = createDirection(mapItems[3], mapItems[4])
        drawDirection(fourDirection)
        let fiveDirection = createDirection(mapItems[4], mapItems[5])
        drawDirection(fiveDirection)
        let sixDirection = createDirection(mapItems[5], mapItems[6])
        drawDirection(sixDirection)
    }
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "PublicPOI_tat", ofType: "json") else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))

        guard let data = optionalData else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data) else { return }
        guard let dictionary = json as? [[String: Any]] else { return }
        for item in dictionary {
            let title = item["title"] as? String
            let locationName = item["locationName"] as? String
            let discipline = item["discipline"] as! String
            let latitude = Double(item["latitude"] as! String)
            let longitude = Double(item["longitude"] as! String)
            let p = POIwork(title: title!, locationName: locationName!, discipline: discipline, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            poiworks.append(p)
        }
    }
    
    func createDirection(_ sourceMapItem: MKMapItem, _ destinationMapItem: MKMapItem) -> MKDirections {
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        return directions;
    }

    func drawDirection(_ directions: MKDirections) {
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.plotPolyline(route: route)
        }

    }
    
    func plotPolyline(route: MKRoute) {
        mapView.addOverlay(route.polyline)
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
        }
        else {
            let polylineBoundingRect =  mapView.visibleMapRect.union(route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect, animated: false)
        }
    }
    // [sourceAnnotation, viaAnnotation, destinationAnnotation]
    func showAnnotation(_ annotations: [MKAnnotation]) {
        self.mapView.showAnnotations(annotations, animated: true )
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
        
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func MapIAmHere(_ sender: Any) {
        showImHere(self.mapView)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? POIwork else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
