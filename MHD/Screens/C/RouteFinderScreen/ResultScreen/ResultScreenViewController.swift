//
//
//
// Created by: Patrik Drab on 20/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class ResultScreenViewController: UIViewController, MHD_NavigationDelegate {
    var contentLabelText: NSAttributedString {
        let fromStationName = searchRouteModel.fromStationInfo.stationName ?? ""
        let toStationName = searchRouteModel.toStationInfo.stationName ?? ""
        let selectedDay = searchRouteModel.formattedSelectedDay
        let time = searchRouteModel.formattedTime
        
        return NSAttributedStringBuilder()
            .add(text: "Zo zastávky ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(fromStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "na ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(toStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "\(selectedDay) od ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(time) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    private let addToFavoriteBtn = CustomButton.makeCircleBtn(
        iconName: "heart",
        iconColor: .white,
        iconSize: 24,
        backgroundColor: .systemBlue,
        size: 50
    )
    
    let searchRouteModel: RouteFinderModel
    
    var itemExists: Bool = false
    
    init(searchRouteModel: RouteFinderModel) {
        self.searchRouteModel = searchRouteModel
        super.init(nibName: nil, bundle: nil)
        self.itemExists = checkIfItemExists()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        setFavoriteBtn()
    }
    
    private func checkIfItemExists() -> Bool {
        guard let fromStationName = searchRouteModel.fromStationInfo.stationName,
              let toStationName = searchRouteModel.toStationInfo.stationName else { return false }
        
        let context = MHD_CoreDataManager.shared.viewContext
        return MHD_Favorite.checkIfItemExists(
            for: fromStationName,
            and: toStationName,
            in: context
        )
    }
    
    private func setFavoriteBtn() {

        addToFavoriteBtn.onRelease = { [weak self] in
            guard let self else { return }
            
            let context = MHD_CoreDataManager.shared.viewContext
            
            if !itemExists {
                MHD_Favorite.addToFavorite(searchRouteModel, in: context)
                itemExists = true
                addToFavoriteBtn.setButtonIcon("heart.fill")
            } else {
                print("Item exist.")
                
                // TODO
                // implement pop information about item existing.
            }
        }
        addToFavoriteBtn.setButtonIcon(itemExists ? "heart.fill" : "heart")
        
        view.addSubview(addToFavoriteBtn)
        addToFavoriteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToFavoriteBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addToFavoriteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
