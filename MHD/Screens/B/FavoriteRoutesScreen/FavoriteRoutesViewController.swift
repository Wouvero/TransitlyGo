//
//
//
// Created by: Patrik Drab on 21/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import SwiftUI


class FavoriteRoutesViewController: UIViewController, MHD_NavigationDelegate {
    
    
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Obľúbené", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    private let context = MHD_CoreDataManager.shared.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoriteView = FavoriteView(vm: FavoriteViewModel()) { [weak self] favorite in
            self?.handleNavigation(for: favorite)
        }
        let hostingController = UIHostingController(rootView: favoriteView)
        
        attachSwiftUIHostingController(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.backgroundColor = .neutral10
    }
    
    private func handleNavigation(for item: MHD_Favorite) {
        guard let fromStationName = item.fromStation,
              let toStationName = item.toStation else { return }
        
        guard let fromStation = MHD_StationInfo.getStationInfo(withName: fromStationName, in: context),
              let toStation = MHD_StationInfo.getStationInfo(withName: toStationName, in: context) else { return }
        
        let vc = RouteFinderViewController()
        navigate(to: vc)
        
        DispatchQueue.main.async {
            vc.searchRouteVM.fromStationInfo = fromStation
            vc.searchRouteVM.toStationInfo = toStation
        }
    }
}

extension UIViewController {
    func attachSwiftUIHostingController(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

