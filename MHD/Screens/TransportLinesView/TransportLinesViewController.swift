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
                .add(text: "Zoznam liniek", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
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




//
//protocol CustomCollectionViewDelegate: AnyObject {
//    func didSelectItem(_ item: Line)
//}




/// ⚠️ It will be remove - I dont use it
//extension UINavigationController {
//    func setupCustomNavigationBar() {
//        // Standard appearance
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = Colors.primary
//        appearance.titleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
//        ]
//
//        // Remove bottom border/shadow
//        appearance.shadowColor = nil
//        appearance.shadowImage = UIImage()
//
//        // Back button
//        appearance.setBackIndicatorImage(
//            UIImage(systemName: "chevron.left"),
//            transitionMaskImage: UIImage(systemName: "chevron.left")
//        )
//
//        // Apply to all states
//        navigationBar.standardAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
//        navigationBar.compactAppearance = appearance
//
//        // Other customizations
//        navigationBar.tintColor = .systemBlue
//        navigationBar.isTranslucent = false
//    }
//}

//
//class NavigationBar: UINavigationBar {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        isHidden = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


//transportLinesCollection.delegate = self



//    func didSelectItem(_ item: Line) {
//        let routeViewController = RoutesViewController(line: item)
//        navigationController?.pushViewController(routeViewController, animated: true)
//    }
