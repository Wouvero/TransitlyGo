//
//
//
// Created by: Patrik Drab on 23/03/2025
// Copyright (c) 2025 MHD
//
//


import UIKit
import UIKitTools
import SwiftUI
import CoreData


class TransportLinesViewController: UIViewController {
    static let reuseIdentifier = "TransportLinesViewController"
    
    private let transportLinesCollection = TransportLinesCollectionView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
}

// MARK: - Setup
private extension TransportLinesViewController {
    func initialSetup() {
        view.backgroundColor = .systemBackground
        setupTransportLineCollectionView()
        generateInitialData()
        fetchTransportLines()
    }
    
    func setupTransportLineCollectionView() {
        view.addSubview(transportLinesCollection)
        transportLinesCollection.pinToSuperviewSafeAreaLayoutGuide()
    }
    
    func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Zoznam liniek", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .bold)])
                .build()
  
            navController.setTitle(attributedText)
        }
    }
}

// MARK: - Data Handling
private extension TransportLinesViewController {
    func generateInitialData() {
        let context = CoreDataManager.shared.viewContext
        CDTransportLine.generateDummyData(in: context)
    }
    
    func fetchTransportLines() {
        let context = CoreDataManager.shared.viewContext
        let request: NSFetchRequest<CDTransportLine> = CDTransportLine.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "indexPosition", ascending: true)]
        
        do {
            let lines = try context.fetch(request)
            transportLinesCollection.update(with: lines)
        } catch {
            print("🔴 Fetch transport lines failed: \(error.localizedDescription)")
        }
    }
}


struct TransportLinesViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview{
            TransportLinesViewController()
        }.ignoresSafeArea(.all)
    }
}
