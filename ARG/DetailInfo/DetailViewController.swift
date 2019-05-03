//
//  DetailViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 03/05/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let chashaImages: [UIImage] = [
        UIImage(named: "карусель1")!,
        UIImage(named: "карусель2")!,
        UIImage(named: "карусель3")!,
        UIImage(named: "карусель4")!
    ]
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var nightViewButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var ticketButton: UIButton!
    
    @IBOutlet weak var infoPanel: UIView!
    @IBOutlet weak var photosPanel: UIView!

    @IBOutlet weak var infoHeartButton: UIButton!
    @IBOutlet weak var photosHeartButton: UIButton!
    
    var infoHeartState = false
    var photosHeartState = false
    var nightViewHeartState = false
    var hestoryHeartState = false
    var ticketHeartState = false

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
        infoHeartState = false
        photosHeartState = false
        nightViewHeartState = false
        hestoryHeartState = false
        ticketHeartState = false

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downSwipe.direction = .down
        
        infoPanel.addGestureRecognizer(downSwipe)
        photosPanel.addGestureRecognizer(downSwipe)
        
        hideAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chashaImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! CollectionViewCell
        cell.photoItem.image = chashaImages[indexPath.item]
        
        return cell
    }
    
    func hideAll() {
        infoPanel.isHidden = true
        photosPanel.isHidden = true
    }
    
    @IBAction func infoButtonTouchUpInside(_ sender: UIButton) {
        hideAll()
        infoPanel.isHidden = false
    }
    
    @IBAction func photosButtonTouchUpInside(_ sender: UIButton) {
        hideAll()
        photosPanel.isHidden = false
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .down:
                debugPrint("down")
                dismiss(animated: true)
                //            case .left:
            //                debugPrint("left")
            default:
                debugPrint("default")
            }
        }
    }
    
    @IBAction func heartTouchUpInside(_ sender: Any) {
        if infoHeartState == false {
            infoHeartButton.setImage(UIImage(named: "heart-active.png"), for: .normal)
            infoHeartState = true
        }else {
            infoHeartButton.setImage(UIImage(named: "heart.png"), for: .normal)
            infoHeartState = false
        }
    }
    
    @IBAction func photoHeartTouchUpInside(_ sender: UIButton) {
        if photosHeartState == false {
            photosHeartButton.setImage(UIImage(named: "heart-active.png"), for: .normal)
            photosHeartState = true
        }else {
            photosHeartButton.setImage(UIImage(named: "heart.png"), for: .normal)
            photosHeartState = false
        }
    }
}
