//
//  FindViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 09/04/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit

class FindViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ExitButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
