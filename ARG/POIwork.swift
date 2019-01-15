//
//  POIwork.swift
//  ARG
//
//  Created by Sergei Karimov on 15/01/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import MapKit
import Contacts

class POIwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D

    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }

//    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.locationName = locationName
//        self.discipline = discipline
//        self.coordinate = coordinate
//
//        super.init()
//    }
    
    var subtitle: String? {
        return locationName
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
//    func mapItem() -> MKMapItem {
//        let addressDict = [CNPostalAddressStreetKey: subtitle!]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = title
//        return mapItem
//    }
}
