//
//  Route.swift
//  ARG
//
//  Created by Sergei Karimov on 22/01/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class Route {
    var title: String
    var img: UIImage
    var description: String
    
    init(title: String, image: UIImage, description: String) {
        
        self.title = title
        self.img = image
        self.description = description
    }
}
