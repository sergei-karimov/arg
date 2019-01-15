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
        
//        do {
//            showImHere(mapView)
//        } catch {
//            NSLog(error as! String)
//        }
        
//        var annotations: [MKAnnotation] = []
//        var locationTuples: [(mapItem: MKMapItem, annotation: MKAnnotation)]!
//
//        locationTuples = prepareRoute()
//        for (_, a) in locationTuples { annotations.append(a) }
//
//        let oneDirection = createDirection(locationTuples[0].mapItem, locationTuples[1].mapItem)
//        drawDirection(oneDirection)
//        let twoDirection = createDirection(locationTuples[1].mapItem, locationTuples[2].mapItem)
//        drawDirection(twoDirection)
//        let threeDirection = createDirection(locationTuples[2].mapItem, locationTuples[3].mapItem)
//        drawDirection(threeDirection)
//        let fourDirection = createDirection(locationTuples[3].mapItem, locationTuples[4].mapItem)
//        drawDirection(fourDirection)
//        let fiveDirection = createDirection(locationTuples[4].mapItem, locationTuples[5].mapItem)
//        drawDirection(fiveDirection)
//        let sixDirection = createDirection(locationTuples[5].mapItem, locationTuples[6].mapItem)
//        drawDirection(sixDirection)
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
    
    func prepareRoute() -> [(MKMapItem, MKAnnotation)] {
        // point_one: Музей «Портомойня» ул. малая покровская 9
        // point_two: Дом памяти М.И. Цветаевой ул. Малая покровская 20 (билет 150р) Аудио Гид
        // point_three: площадь и памятник-бюст М.И. Цветаевой ул. малая покровская/Казанская
        // point_four: Библиотека Серебряного века ул. Казанская 61 (билет 50р)
        // point_five: Литературный музей М.И. Цветаевой   (есть аудиогид) (билет 100р) ул. Казанская 61
        // point_six: Покровская церковь ул. Казанская 4
        // point_seven: могила М.И. Цветаевой на Петропавловском кладбище  ул.Тугарова
        
        // 2. Set the latitude and longtitude of the locations
        let point_one = CLLocationCoordinate2D(latitude: 55.755607, longitude: 52.0695783)
        let point_two = CLLocationCoordinate2D(latitude: 55.7551569, longitude: 52.0698144)
        let point_three = CLLocationCoordinate2D(latitude: 55.7544825, longitude: 52.0693448)
        let point_four = CLLocationCoordinate2D(latitude: 55.754717, longitude: 52.0686564)
        let point_five = CLLocationCoordinate2D(latitude: 55.754717, longitude: 52.0686564)
        let point_six = CLLocationCoordinate2D(latitude: 55.7578106, longitude: 52.0405674)
        let point_seven = CLLocationCoordinate2D(latitude: 55.771964, longitude: 52.0739098)

        // 3. Create placemark objects containing the location's coordinates
        let onePlacemark = MKPlacemark(coordinate: point_one, addressDictionary: nil)
        let twoPlackmark = MKPlacemark(coordinate: point_two, addressDictionary: nil)
        let threePlacemark = MKPlacemark(coordinate: point_three, addressDictionary: nil)
        let fourPlacemark = MKPlacemark(coordinate: point_four, addressDictionary: nil)
        let fivePlacemark = MKPlacemark(coordinate: point_five, addressDictionary: nil)
        let sixPlacemark = MKPlacemark(coordinate: point_six, addressDictionary: nil)
        let sevenPlacemark = MKPlacemark(coordinate: point_seven, addressDictionary: nil)

        // 4. MKMapitems are used for routing. This class encapsulates information about a specific point on the map
        let oneMapItem = MKMapItem(placemark: onePlacemark)
        let twoMapItem = MKMapItem(placemark: twoPlackmark)
        let threeMapItem = MKMapItem(placemark: threePlacemark)
        let fourMapItem = MKMapItem(placemark: fourPlacemark)
        let fiveMapItem = MKMapItem(placemark: fivePlacemark)
        let sixMapItem = MKMapItem(placemark: sixPlacemark)
        let sevenMapItem = MKMapItem(placemark: sevenPlacemark)

        // 5. Annotations are added which shows the name of the placemarks
        let oneAnnotation = MKPointAnnotation()
        oneAnnotation.title = "Музей \"Портомойня\""
        
        if let location = onePlacemark.location {
            oneAnnotation.coordinate = location.coordinate
        }
        
        let twoAnnotation = MKPointAnnotation()
        twoAnnotation.title = "Дом памяти М.И. Цветаевой"
        
        if let location = twoPlackmark.location {
            twoAnnotation.coordinate = location.coordinate
        }
        
        let threeAnnotation = MKPointAnnotation()
        threeAnnotation.title = "Памятник-бюст М.И. Цветаевой"
        
        if let location = threePlacemark.location {
            threeAnnotation.coordinate = location.coordinate
        }
        
        let fourAnnotation = MKPointAnnotation()
        fourAnnotation.title = "Библиотека Серебряного века"
        
        if let location = fourPlacemark.location {
            fourAnnotation.coordinate = location.coordinate
        }
        
        let fiveAnnotation = MKPointAnnotation()
        fiveAnnotation.title = "Литературный музей М.И. Цветаевой"
        
        if let location = fivePlacemark.location {
            fiveAnnotation.coordinate = location.coordinate
        }
        
        let sixAnnotation = MKPointAnnotation()
        sixAnnotation.title = "Покровская церковь"
        
        if let location = sixPlacemark.location {
            sixAnnotation.coordinate = location.coordinate
        }
        
        let sevenAnnotation = MKPointAnnotation()
        sevenAnnotation.title = "Могила М.И. Цветаевой"
        
        if let location = sevenPlacemark.location {
            sevenAnnotation.coordinate = location.coordinate
        }
        
        return [(oneMapItem, oneAnnotation), (twoMapItem, twoAnnotation), (threeMapItem, threeAnnotation), (fourMapItem, fourAnnotation), (fiveMapItem, fiveAnnotation), (sixMapItem, sixAnnotation), (sevenMapItem, sevenAnnotation)]
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
