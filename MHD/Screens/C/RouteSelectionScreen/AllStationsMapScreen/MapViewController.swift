//
//
//
// Created by: Patrik Drab on 19/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MHD_NavigationDelegate {
    // MARK: - Properties
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Mapa všetkých zastávok", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    var fieldType: InputFieldType = .from
    
    func shouldHideTabBar() -> Bool { true }
    
    private let mapView = MHD_GlobalStationsMap()
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        
        setupMapView()
        fetchAllStations()
    }
    
}


extension MapViewController {
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchAllStations() {
        let context = MHD_CoreDataManager.shared.viewContext
        let request: NSFetchRequest<MHD_StationInfo> = MHD_StationInfo.fetchRequest()
    
        do {
            let stations = try context.fetch(request)
            mapView.setStations(stations)
        } catch {
            print("🔴 Fetch transport lines failed: \(error.localizedDescription)")
        }
    }
    
}

import UIKitPro
import SwiftUI
import CoreData

struct MapViewControllerPreview: PreviewProvider {
    static var previews: some View {
        return ViewControllerPreview {
            MapViewController()
        }
    }
}
