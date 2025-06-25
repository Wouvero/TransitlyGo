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


class MapViewController: UIViewController, MapViewDelegate {
    // MARK: - Properties
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Mapa všetkých zastávok", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    var fieldType: InputFieldType = .from
    
    func shouldHideTabBar() -> Bool { true }
    
    private let mapView = AllStationMapView()

    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    private let loadingContainer = UIView()
    
    private var loadingFallbackTimer: Timer?
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        
        fetchAllStations()
        setupMapView()
        setupLoadingView()
        
        startLoadingFallbackTimer()
    }
    
}


extension MapViewController {
    func mapDidFinishRendering(_ mapView: MKMapView, fullyRendered: Bool) {
        hideLoadingView()
    }
    
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
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
    
    private func setupLoadingView() {
        loadingContainer.backgroundColor = .systemBackground
        loadingContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingContainer)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        loadingContainer.addSubview(loadingIndicator)
        
        loadingLabel.text = "Map is loading, please wait..."
        loadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingContainer.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingContainer.topAnchor.constraint(equalTo: view.topAnchor),
            loadingContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
        ])
    }
    
    private func startLoadingFallbackTimer() {
        // Fallback in case map rendering never completes
        loadingFallbackTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: false
        ) { [weak self] _ in
            self?.hideLoadingView()
        }
    }
    
    private func hideLoadingView() {
        // Cancel the fallback timer
        loadingFallbackTimer?.invalidate()
        loadingFallbackTimer = nil
        
        UIView.animate(withDuration: 0.3) {
            self.loadingContainer.alpha = 0
        } completion: { _ in
            self.loadingContainer.removeFromSuperview()
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
