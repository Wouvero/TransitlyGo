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
    
    private let addToFavoriteBtn = CustomButton(
        type: .iconOnly(
            iconName: SFSymbols.bus_fill,
            iconColor: .neutral,
            iconSize: 20
        ),
        style: .filled(
            backgroundColor: .primary500,
            cornerRadius: 22
        ),
        size: .custom(width: 44, height: 44)
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
    
    private func saveFavoriteRoute(customName: String) {
        let context = MHD_CoreDataManager.shared.viewContext
        MHD_Favorite.add(
            searchRouteModel,
            with: customName,
            in: context
        )
        
        itemExists = true
        addToFavoriteBtn.setButtonIcon(SFSymbols.heart_fill)
        showSuccessAlert()
    }
    
    private func showNameInputAlert() {
        let alert = TextFieldAlertView()
        alert.titleText = "Názov obľúbenej položky"
        alert.messageText = "Napr. Do práce. K rodičom, atď..."
        
        alert.affirmativeAction = { [weak self] in
            guard let name = alert.textField.text?.trimmingCharacters(in: .whitespaces),
                  !name.isEmpty else { return }
            self?.saveFavoriteRoute(customName: name)
            alert.close()
        }
        alert.dismissiveAction = {
            alert.close()
        }
        alert.show(on: self)
    }
    
    private func showAlreadyExistsAlert() {
        let alert = SystemAlertView()
        alert.titleText = "Už uložené"
        alert.messageText = "Túto trasu už máte v obľúbených."
        alert.affirmativeButton.setButtonLabelText("OK")
        alert.affirmativeAction = {
            alert.close()
        }
        alert.show(on: self)
    }
    
    private func showSuccessAlert() {
        let alert = SystemAlertView()
        alert.titleText = "🎉 Uložené"
        alert.messageText = "Trasa bola uložena v obľúbených."
        alert.affirmativeButton.setButtonLabelText("OK")
        alert.affirmativeAction = {
            alert.close()
        }
        alert.show(on: self)
    }
    
    private func setFavoriteBtn() {

        addToFavoriteBtn.onRelease = { [weak self] in
            guard let self else { return }
            
            if itemExists {
                showAlreadyExistsAlert()
            } else {
                showNameInputAlert()
            }
        }
        
        addToFavoriteBtn.setButtonIcon(itemExists ? SFSymbols.heart_fill : SFSymbols.heart_line)
        view.addSubview(addToFavoriteBtn)
        addToFavoriteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToFavoriteBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addToFavoriteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
