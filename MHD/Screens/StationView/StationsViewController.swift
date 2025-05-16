//
//
//
// Created by: Patrik Drab on 13/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import SwiftUI
import UIKitTools


class StationController: UIViewController {
    static let reuseIdentifier = "StationController"

    private let direction: CDDirection
    private var stations: [CDStation] {
        return direction.stations?.allObjects as? [CDStation] ?? []
    }
    let stationTable = StationsTable()
    
    
    init(direction: CDDirection) {
        self.direction = direction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(direction:) instead. This controller doesn't support Storyboards.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(stationTable)
        stationTable.pinToSuperviewSafeAreaLayoutGuide()
        stationTable.update(with: stations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            
            let transportLineName = direction.line?.name ?? ""
            let destinationStationName = direction.destinationStation?.stationName ?? ""
            
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Linka č. ", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .add(text: "\(transportLineName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: navigationBarTitleSize)])
                .add(text: "smer ", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .add(text: "\(destinationStationName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: navigationBarTitleSize)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}
//
//struct StationController_Prewiews: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            StationController(transportLine: Line.allLines[0], destination: "Route A")
//        }.ignoresSafeArea()
//    }
//}

