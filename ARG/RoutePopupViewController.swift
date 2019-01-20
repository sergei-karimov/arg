//
//  RoutePopupViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 20/01/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class RoutePopupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectRoute: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectRoute_TouchUpInside(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
