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
    @IBOutlet weak var nightViewPanel: UIView!
    @IBOutlet weak var historyPanel: UIView!
    @IBOutlet weak var ticketPanel: UIView!

    @IBOutlet weak var infoHeartButton: UIButton!
    @IBOutlet weak var photosHeartButton: UIButton!
    @IBOutlet weak var nightViewHeartButton: UIButton!
    @IBOutlet weak var historyHeartButton: UIButton!
    @IBOutlet weak var ticketHeartButton: UIButton!

    @IBOutlet weak var openCloseLabel: UILabel!
    @IBOutlet weak var closeAfterLabel: UILabel!
    
    var infoHeartState = false
    var photosHeartState = false
    var nightViewHeartState = false
    var historyHeartState = false
    var ticketHeartState = false

    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 10 && hour < 19 {
            openCloseLabel.text = "Открыто"
            closeAfterLabel.text = "Закроется через \(19 - hour) часов"
        }else {
            if hour < 10 {
                openCloseLabel.text = "Закрыто"
                closeAfterLabel.text = "Откроется через \(10 - hour) часов"
            }
            
            if hour >= 19 {
                openCloseLabel.text = "Закрыто"
                closeAfterLabel.text = "Откроется через \(34 - hour) часов"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
        infoHeartState = false
        photosHeartState = false
        nightViewHeartState = false
        historyHeartState = false
        ticketHeartState = false

        let downInfoSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downInfoSwipe.direction = .down
        
        let downPhotosSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downPhotosSwipe.direction = .down

        let downNightViewSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downNightViewSwipe.direction = .down

        let downHistorySwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downHistorySwipe.direction = .down

        let downTicketSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downTicketSwipe.direction = .down

        infoPanel.addGestureRecognizer(downInfoSwipe)
        photosPanel.addGestureRecognizer(downPhotosSwipe)
        nightViewPanel.addGestureRecognizer(downNightViewSwipe)
        historyPanel.addGestureRecognizer(downHistorySwipe)
        ticketPanel.addGestureRecognizer(downTicketSwipe)

        hideAll()
        
        infoPanel.isHidden = false
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
        nightViewPanel.isHidden = true
        historyPanel.isHidden = true
        ticketPanel.isHidden = true
    }
    
    @IBAction func infoButtonTouchUpInside(_ sender: UIButton) {
        hideAll()
        infoPanel.isHidden = false
    }
    
    @IBAction func photosButtonTouchUpInside(_ sender: UIButton) {
        hideAll()
        photosPanel.isHidden = false
    }
    
    @IBAction func nightViewTouchUpInside(_ sender: UIButton) {
        hideAll()
        nightViewPanel.isHidden = false
    }

    @IBAction func historyTouchUpInside(_ sender: UIButton) {
        hideAll()
        historyPanel.isHidden = false
    }
    
    @IBAction func ticketTouchUpInside(_ sender: UIButton) {
        hideAll()
        ticketPanel.isHidden = false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLargeImage" {
            if let indexPatrhs = collectionView?.indexPathsForSelectedItems {
                let destinationController = segue.destination as! LargeImageViewController
                destinationController.imageName = "карусель\(indexPatrhs[0].row + 1).jpg"
                collectionView?.deselectItem(at: indexPatrhs[0], animated: false)
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
    
    @IBAction func nightViewHeartTouchUpInside(_ sender: UIButton) {
        if nightViewHeartState == false {
            nightViewHeartButton.setImage(UIImage(named: "heart-active.png"), for: .normal)
            nightViewHeartState = true
        }else {
            nightViewHeartButton.setImage(UIImage(named: "heart.png"), for: .normal)
            nightViewHeartState = false
        }
    }
    
    @IBAction func historyHeartTouchUpInside(_ sender: UIButton) {
        if historyHeartState == false {
            historyHeartButton.setImage(UIImage(named: "heart-active.png"), for: .normal)
            historyHeartState = true
        }else {
            historyHeartButton.setImage(UIImage(named: "heart.png"), for: .normal)
            historyHeartState = false
        }
    }
    
    @IBAction func ticketHeartTouchUpInside(_ sender: UIButton) {
        if ticketHeartState == false {
            ticketHeartButton.setImage(UIImage(named: "heart-active.png"), for: .normal)
            ticketHeartState = true
        }else {
            ticketHeartButton.setImage(UIImage(named: "heart.png"), for: .normal)
            ticketHeartState = false
        }
    }
}
