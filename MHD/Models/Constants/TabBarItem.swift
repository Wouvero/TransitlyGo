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
    let viewControllerProvider: () -> UIViewController
}

extension TabBarItem {
    static let tabBarItems: [TabBarItem] = [
        TabBarItem(
            title: "View 1",
            icon: "house",
            viewControllerProvider: { TransportLinesViewController() }
        ),
        TabBarItem(
            title: "View 2",
            icon: "heart",
            viewControllerProvider: { FavoriteRoutesViewController() }
        ),
        TabBarItem(
            title: "View 3",
            icon: "magnifyingglass",
            viewControllerProvider: { RouteFinderViewController() }
        ),
    ]
}


