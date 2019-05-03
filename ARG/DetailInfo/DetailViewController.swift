//
//  DetailViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 03/05/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var nightViewButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var ticketButton: UIButton!
    @IBOutlet weak var infoPanel: UIView!
    @IBOutlet weak var heartButton: UIButton!
    
    var heartState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        heartState = false
    }
    
    @IBAction func heartTouchUpInside(_ sender: Any) {
        if heartState == false {
            heartButton.setImage(UIImage(named: "heart-active.png"), for: .normal)
            heartState = true
        }else {
            heartButton.setImage(UIImage(named: "heart.png"), for: .normal)
            heartState = false
        }
    }
}
