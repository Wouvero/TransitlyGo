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
        let dateSelection = formatDate(searchRouteModel.selectedDate)
        let time = searchRouteModel.hour + ":" + searchRouteModel.minute
        
        return NSAttributedStringBuilder()
            .add(text: "Zo zastávky ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(fromStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "na ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(toStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "\(dateSelection) od ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(time) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    let searchRouteModel: SearchRouteModel
    
    init(searchRouteModel: SearchRouteModel) {
        self.searchRouteModel = searchRouteModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
    }
}
