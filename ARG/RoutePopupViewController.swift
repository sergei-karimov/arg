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
    @IBOutlet weak var routeList: UITableView!
    @IBOutlet weak var tableView: UITableView!
    var onSave: ((_ data: String) -> ())?

    var routes: [Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routes = createRoutes()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func createRoutes() -> [Route]{
        var tmp: [Route] = []
        
        let image_1: UIImage! = UIImage(named: "n_main-active")
//        let image_2: UIImage! = UIImage(named: "ГЛАВНАЯ активная")
//        let image_3: UIImage! = UIImage(named: "ГЛАВНАЯ активная")

        let route_1 = Route(title: "Цветаева", image: image_1, description: "Прогулка по Цветаевским местам")
//        let route_2 = Route(title: "Цветаева_№2", image: image_2, description: "Экскурсия Елабуге")
//        let route_3 = Route(title: "Цветаева_№3", image: image_3, description: "Обзорная экскурсия")

        tmp += [route_1 /*, route_2, route_3*/]
        
        return tmp
    }
    
    @IBAction func selectRoute_TouchUpInside(_ sender: UIButton) {
        
        onSave?(routes[0].title)
        
        dismiss(animated: true)
    }
}

extension RoutePopupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let route = routes[0]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell") as! RouteCell
        cell.setRoute(route: route)
            
        return cell
    }
}
