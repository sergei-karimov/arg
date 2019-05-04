//
//  LargeImageViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 04/05/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class LargeImageViewController: UIViewController {
    var imageName: String = ""

    @IBOutlet weak var largeImageView: UIImageView! {
        didSet {
            largeImageView.image = UIImage(named: imageName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downSwipe.direction = .down

        largeImageView.isUserInteractionEnabled = true
        largeImageView.addGestureRecognizer(downSwipe)
    }

    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .down:
                dismiss(animated: true)
            default:
                debugPrint("default")
            }
        }
    }
}
