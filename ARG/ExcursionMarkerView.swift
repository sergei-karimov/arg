//
//  ExcursionMarkerView.swift
//  ARG
//
//  Created by Sergei Karimov on 09/04/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import MapKit

//  MARK: Excursion Marker View
internal final class ExcursionMarkerView: MKMarkerAnnotationView {
    //  MARK: Properties
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
}
//  MARK: Configuration
private extension ExcursionMarkerView {
    func configure(with annotation: MKAnnotation) {
        guard annotation is POIwork else { fatalError("Unexpected annotation type: \(annotation)") }
        markerTintColor = .purple
        glyphImage = #imageLiteral(resourceName: "geo_fence")
    }
}
