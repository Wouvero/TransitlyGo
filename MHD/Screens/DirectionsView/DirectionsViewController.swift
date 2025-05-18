//
//
//
// Created by: Patrik Drab on 06/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import UIKitTools
import SwiftUI


class DirectionsViewController: UIViewController {
    static let reuseIdentifier = "RoutesViewController"

    private let transportLine: CDTransportLine
    private var transportLineIdentificator: UILabel!
    private var directionText: UILabel!
    private var routeDestinationA: UILabel!
    private var routeDestinationB: UILabel!
    
    
    private var directions: [CDDirection] {
        return transportLine.directions?.allObjects as? [CDDirection] ?? []
    }
    
    init(for transportLine: CDTransportLine) {
        self.transportLine = transportLine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(transportLine:) instead. This controller doesn't support Storyboards.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        transportLineIdentificator = UILabel(
            text: transportLine.name,
            font: .boldSystemFont(ofSize: 48),
            textColor: .black,
            textAlignment: .center,
            numberOfLines: 1
        )
        
        directionText = UILabel(
            text: "Smer na",
            font: .systemFont(ofSize: 14, weight: .regular),
            textColor: .gray,
            textAlignment: .center,
            numberOfLines: 1
        )
        
        
        routeDestinationA = UILabel(
            text: "\(directions[0].destinationStation?.stationName ?? "")",
            font: .boldSystemFont(ofSize: 24),
            textColor: .black,
            textAlignment: .center,
            numberOfLines: 0
        )
        
        routeDestinationB = UILabel(
            text: "\(directions[1].destinationStation?.stationName ?? "")",
            font: .boldSystemFont(ofSize: 24),
            textColor: .black,
            textAlignment: .center,
            numberOfLines: 0
        )
        
        routeDestinationB.setWidth(200)
        routeDestinationA.setWidth(200)
        routeDestinationA.setBackground(.gray)
        routeDestinationB.setBackground(.gray)
        
        let routeOneView = UIView(color: .white)
        routeOneView.addSubview(routeDestinationA)
        routeDestinationA.pinInSuperview(padding: .equalSides(5))
        routeOneView.asButton {
            self.moveToStations(for: self.directions[0])
        }
        
        let routeTwoView = UIView(color: .white)
        routeTwoView.addSubview(routeDestinationB)
        routeDestinationB.pinInSuperview(padding: .equalSides(5))
        routeTwoView.asButton {
            self.moveToStations(for: self.directions[1])
        }
        
        
        
        let stackRouteView = UIStackView(
            arrangedSubviews: [
                routeOneView,
                routeTwoView
            ],
            axis: .horizontal,
            spacing: 10,
            alignment: .center,
            distribution: .fill
        )
        
        let wholeStack = UIStackView(
            arrangedSubviews: [
                transportLineIdentificator,
                directionText,
                stackRouteView,
            ],
            axis: .vertical,
            spacing: 40,
            alignment: .center,
            distribution: .fill
        )
        wholeStack.setCustomSpacing(10, after: transportLineIdentificator)
        
        
        view.addSubview(wholeStack)
        wholeStack.center()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            let transportLineName = transportLine.name ?? ""
            
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Linka č. ", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .add(text: "\(transportLineName)", attributes: [.font: UIFont.boldSystemFont(ofSize: navigationBarTitleSize)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
    
    private func moveToStations(for direction: CDDirection) {
        let stationViewController = StationController(direction: direction)
        navigationController?.pushViewController(stationViewController, animated: true)
    }
}
//
//struct RouteViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            RoutesViewController(for: Line.allLines[0])
//        }
//        .ignoresSafeArea()
//    }
//}
