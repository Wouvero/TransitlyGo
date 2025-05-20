//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//

import UIKit

struct TabBarItem {
    let title: String
    let icon: String
    let viewController: UIViewController
}

extension TabBarItem {
    static let tabBarItems: [TabBarItem] = [
        TabBarItem(
            title: "Stations",
            icon: SFSymbols.bus,
            viewController: TransportLinesViewController()
        ),
        TabBarItem(
            title: "Favorite",
            icon: SFSymbols.favorite,
            viewController: UIViewController()
        ),
        TabBarItem(
            title: "SearchBar",
            icon: SFSymbols.search,
            viewController: SearchConectionViewController()
        ),
//        TabBarItem(
//            title: "Map",
//            icon: SFSymbols.map,
//            viewController: MapViewController()
//        ),
//        TabBarItem(
//            title: "Route",
//            icon: SFSymbols.station,
//            viewController: StationsListViewController()
//        )
    ]
}


