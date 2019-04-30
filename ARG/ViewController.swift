//
//  ViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 18/12/2018.
//  Copyright © 2018 Sergei Karimov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    var location: CLLocation!
    @IBOutlet weak var cabinetButton: UIButton!
    @IBOutlet weak var myRouteButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    
    //    @IBOutlet weak var plusBtnClicked: UITapGestureRecognize!
    @IBOutlet weak var mainImgBtn: UIImageView!
//    @IBOutlet weak var excurtionImgBtn: UIImageView!
//    @IBOutlet weak var myRouteImgBtn: UIImageView!
//    @IBOutlet weak var cabnetImgBtn: UIImageView!
    @IBOutlet weak var excursionImgBtn: UIButton!
    @IBOutlet weak var myRouteImgBtn: UIButton!
    @IBOutlet weak var cabinetImgBtn: UIButton!
    @IBOutlet weak var objectsBtnShowHideBtn: UIButton!
    @IBOutlet weak var objectsBtn: UIButton!
    
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
        for pw in poiWorks {
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
        
        hideAll()
        
        mapView.register(ExcursionMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.delegate = self
        determineMyCurrentLocation()
        
//        centerMapOnLocation(location: initialLocation)

        loadInitialData()
        mapView.addAnnotations(poiworks)
        
        showImHere(mapView)
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
//        let lastDelta = mapView.region.span
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
//        centerMapOnLocation(location: userLocation)
//        var center = CLLocationCoordinate2D(latitude: 55.795183, longitude: 48.793128)
//
//        center.latitude = userLocation.coordinate.latitude
//        center.longitude = userLocation.coordinate.longitude
//
//        let span = MKCoordinateSpan(latitudeDelta: lastDelta.latitudeDelta, longitudeDelta: lastDelta.longitudeDelta)
//        let region = MKCoordinateRegion(center: center, span: span)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
        guard let fileName = Bundle.main.path(forResource: "PublicPOI_rus", ofType: "json") else { return }
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.location = locations.last
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func showImHere(_ mapView: MKMapView) {
//        let lastDelta = mapView.region.span

        var center = CLLocationCoordinate2D(latitude: 55.795183, longitude: 48.793128)
        center.latitude = mapView.userLocation.coordinate.latitude 
        center.longitude = mapView.userLocation.coordinate.longitude
        
        //let span = MKCoordinateSpan(latitudeDelta: lastDelta.latitudeDelta, longitudeDelta: lastDelta.longitudeDelta)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
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
    
    @IBAction func showHideObjectsTouchUpInside(_ sender: UIButton) {
        if !objectsBtn.isHidden {
            objectsBtn.isHidden = true
        }else{
            objectsBtn.isHidden = false
        }
    }
    
    @IBAction func MapIAmHere(_ sender: Any) {
//        determineMyCurrentLocation()
        showImHere(self.mapView)
    }
    
    func hideAll() {
        self.cabinetButton.isHidden = true
        self.myRouteButton.isHidden = true
        self.findButton.isHidden = true
    }

    func imgDefault() {
        self.mainImgBtn.image = UIImage(named: "n_main.png")
        self.excursionImgBtn.setImage(UIImage(named: "n_excursions.png"), for: .normal)
        self.myRouteImgBtn.setImage(UIImage(named: "n_marsh.png"), for: .normal)
        self.cabinetImgBtn.setImage(UIImage(named: "n_kab.png"), for: .normal)
    }
    
    @IBAction func kabinet_TouchUpInside(_ sender: UIButton) {
        if self.cabinetButton.isHidden {
            imgDefault()
            hideAll()
            self.cabinetImgBtn.setImage(UIImage(named: "n_kab-active.png"), for: .normal)
            self.cabinetButton.isHidden = false
        } else{
            imgDefault()
            self.mainImgBtn.image = UIImage(named: "n_main-active.png")
            self.cabinetButton.isHidden = true
        }
    }
    @IBAction func myRoute_TouchUpInside(_ sender: UIButton) {
        if self.myRouteButton.isHidden {
            imgDefault()
            hideAll()
            self.myRouteImgBtn.setImage(UIImage(named: "n_marsh-active.png"), for: .normal)
            self.myRouteButton.isHidden = false
        } else {
            imgDefault()
            self.mainImgBtn.image = UIImage(named: "n_main-active.png")
            self.myRouteButton.isHidden = true
        }
    }
    
    @IBAction func search_TouchUpInside(_ sender: UIButton) {
        if self.findButton.isHidden {
            hideAll()
            self.findButton.isHidden = false
        } else {
            self.findButton.isHidden = true
        }
    }
    
    @IBAction func cabinetWindowTouchUpInside(_ sender: UIButton) {
        imgDefault()
        self.mainImgBtn.image = UIImage(named: "n_main-active.png")
        self.cabinetButton.isHidden = true
    }
    
    @IBAction func myRouteWindowTouchUpInside(_ sender: UIButton) {
        imgDefault()
        self.mainImgBtn.image = UIImage(named: "n_main-active.png")
        self.myRouteButton.isHidden = true
    }
    
    @IBAction func searchWindowTouchUpInside(_ sender: UIButton) {
        self.findButton.isHidden = true
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? POIwork else { return nil }
        let identifier = "annotation"
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
