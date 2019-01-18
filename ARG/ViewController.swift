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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        mapView.showsUserLocation = true
//
//        // 1. The ViewController is the delegate of the MKMapViewDelegate protocol
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 55.795183, longitude: 48.793128)
        centerMapOnLocation(location: initialLocation)

        // point_one: latitude: 55.755607, longitude: 52.0695783
        // point_one: Музей «Портомойня» ул. малая покровская 9
//        let museumPortomoiny = POIwork (title: "Музей \"Портомойня\"", locationName: "Елабуга, ул. Малая Покровская, 9", discipline: "Museum", coordinate: CLLocationCoordinate2D(latitude: 55.755607, longitude: 52.0695783))
        
        
        loadInitialData()
        mapView.addAnnotations(poiworks)
        
        do {
            showImHere(mapView)
        } catch {
            NSLog(error as! String)
        }
        
        var annotations: [MKAnnotation] = []
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
//
//        showAnnotation(annotations)
    }
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicPOI_rus", ofType: "json") else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))

//        guard let jsonArray = optionalData as? [[String: Any]] else { return }
//        print(jsonArray)
//        //Now get title value
//        guard let title = jsonArray[0]["title"] as? String else { return }
//        print(title) // delectus aut autem

        guard let data = optionalData else { return }
            // 2
        guard let json = try? JSONSerialization.jsonObject(with: data) else { return }
            // 3
        guard let dictionary = json as? [[String: Any]] else { return }
            // 4
        for item in dictionary {
            let title = item["title"] as? String
            let locationName = item["locationName"] as? String
            let discipline = item["discipline"] as! String
            let latitude = Double(item["latitude"] as! String)
            let longitude = Double(item["longitude"] as! String)
            // 5
            let p = POIwork(title: title!, locationName: locationName!, discipline: discipline, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            poiworks.append(p)
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
//            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
//
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            self.plotPolyline(route: route)
        }

    }
    
    func plotPolyline(route: MKRoute) {
        // 1
        mapView.addOverlay(route.polyline)
        // 2
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
        }
            // 3
        else {
            let polylineBoundingRect =  mapView.visibleMapRect.union(route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect, animated: false)
        }
    }
    // [sourceAnnotation, viaAnnotation, destinationAnnotation]
    func showAnnotation(_ annotations: [MKAnnotation]) {
        // 6. The annotations are displayed on the map
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

extension ViewController: MKMapViewDelegate {
        // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? POIwork else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! POIwork
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
//    }
}
