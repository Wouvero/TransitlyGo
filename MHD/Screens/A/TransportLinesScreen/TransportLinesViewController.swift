//
//
//
// Created by: Patrik Drab on 23/03/2025
// Copyright (c) 2025 MHD
//
//


import UIKit
import UIKitPro
import SwiftUI
import CoreData


class TransportLinesViewController: UIViewController, MHD_NavigationDelegate {
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Zoznam liniek", attributes: [:])
            .build()
    }
    
    static let reuseIdentifier = "TransportLinesViewController"
    
    private let transportLinesCollection = TransportLinesCollectionView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

}

// MARK: - Setup
private extension TransportLinesViewController {
    
    func initialSetup() {
        view.backgroundColor = .neutral10
        setupTransportLineCollectionView()
        generateInitialData()
        fetchTransportLines()
    }
    
    func setupTransportLineCollectionView() {
        view.addSubview(transportLinesCollection)
        transportLinesCollection.pinToSuperviewSafeAreaLayoutGuide()
    }
    
}

// MARK: - Data Handling
private extension TransportLinesViewController {
    func generateInitialData() {
        DummyDataManager.initialData()
    }
    
    func fetchTransportLines() {
        let context = MHD_CoreDataManager.shared.viewContext
        let transportLines = MHD_TransportLine.getAll(in: context)
        transportLinesCollection.update(with: transportLines)
    }
}


struct TransportLinesViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview{
            TransportLinesViewController()
        }.ignoresSafeArea(.all)
    }
}
