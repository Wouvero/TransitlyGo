//
//
//
// Created by: Patrik Drab on 18/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class StationDetailViewController: UIViewController {
    var stationInfo: CDStationInfo
    
    init(stationInfo: CDStationInfo) {
        self.stationInfo = stationInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if let navigationController = navigationController as? NavigationController {
            let attributedText = NSAttributedStringBuilder()
                .add(text: stationInfo.stationName ?? "", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .bold)])
                .build()
            
            navigationController.setTitle(attributedText)
        }
    }
}
