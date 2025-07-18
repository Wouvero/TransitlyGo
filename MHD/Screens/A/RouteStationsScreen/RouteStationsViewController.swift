//
//
//
// Created by: Patrik Drab on 13/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import SwiftUI
import UIKitPro


class RouteStationsController: UIViewController, MHD_NavigationDelegate {
    var contentLabelText: NSAttributedString {
        let transportLineName = direction.transportLine?.name ?? ""
        let destinationStationName = direction.endDestination?.stationName ?? ""
        
        return NSAttributedStringBuilder()
            .add(text: "Linka č. ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(transportLineName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "smer ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(destinationStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    static let reuseIdentifier = "StationController"

    private let direction: MHD_Direction
    private var stations: [MHD_DirectionStation] {
        let station = direction.directionStations?.allObjects as? [MHD_DirectionStation] ?? []
        let sortedStation = station.sorted { $0.sortIndex < $1.sortIndex }
        return sortedStation
    }
    
    var routeStationsTable: RouteStationsTable!
    
    
    init(direction: MHD_Direction) {
        self.direction = direction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(direction:) instead. This controller doesn't support Storyboards.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        setupRouteStationsTable()
        setupMapButton()
    }
    
    private func setupRouteStationsTable() {
        routeStationsTable = RouteStationsTable(with: stations)
        routeStationsTable.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(routeStationsTable)
        
        NSLayoutConstraint.activate([
            routeStationsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            routeStationsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routeStationsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            routeStationsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupMapButton() {
        let mapButton = CustomButton(
            type: .iconOnly(
                iconName: SFSymbols.map_line,
                iconColor: .neutral,
                iconSize: 20
            ),
            style: .filled(backgroundColor: .primary500, cornerRadius: 20),
            size: .custom(width: 40, height: 40)
        )
        mapButton.onRelease = { [weak self] in
            guard let self else { return }
            let vc = RouteStationsMapViewController(direction: direction)
            self.navigate(to: vc)
        }
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapButton)
        
        NSLayoutConstraint.activate([
            mapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
}
