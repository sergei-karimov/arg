//
//  RouteCell.swift
//  ARG
//
//  Created by Sergei Karimov on 22/01/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    
    func setRoute(route: Route) {
        routeImageView.image = route.img
        titleView.text = route.title
        descriptionView.text = route.description
    }
}
