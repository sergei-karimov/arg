//
//  ImageInformationViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 27/01/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class ImageInformationViewController: UICollectionViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDescription: UITextView!
    
    var imageInformation : ImageInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let actualImageInformation = imageInformation {
//            self.imageView.image = actualImageInformation.image
        }
        
        view.backgroundColor = UIColor.red
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
