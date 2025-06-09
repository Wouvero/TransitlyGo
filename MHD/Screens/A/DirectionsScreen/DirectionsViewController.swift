//
//
//
// Created by: Patrik Drab on 06/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import UIKitPro
import SwiftUI


class DirectionsViewController: UIViewController, MHD_NavigationDelegate {
    var contentLabelText: NSAttributedString {
        let transportLineName = transportLine.name ?? ""
        
        return NSAttributedStringBuilder()
            .add(text: "Linka č. ", attributes: [
                .font: UIFont.interRegular(size: 16)
            ])
            .add(text: "\(transportLineName)", attributes: [
                .font: UIFont.interSemibold(size: 16)
            ])
            .build()
    }
    
    
    static let reuseIdentifier = "RoutesViewController"
    
    private let transportLine: MHD_TransportLine
    
    private var transportLineIdentificator = UILabel(
        font: .interSemibold(size: 48),
        textColor: .neutral800,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private var directionText = UILabel(
        text: "Smer na",
        font: .interRegular(size: 14),
        textColor: .neutral700,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private let destinationIcon = IconImageView(
        systemName: SFSymbols.signpost,
        color: .neutral800,
        pointSize: 24
    )
    
    private let content = UIView(color: .neutral10)
    
    private var directionOneButton: CustomButton!
    private var directionTwoButton: CustomButton!
    
    private let directionButtonStack = UIStackView(
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill
    )
    
    private let rootStack = UIStackView(
        axis: .vertical,
        spacing: 32,
        alignment: .center,
        distribution: .fill
    )
    
    private var directions: [MHD_Direction] {
        let directions = transportLine.directions?.allObjects as? [MHD_Direction] ?? []
        let sortedDirection = directions.sorted { $0.sortIndex < $1.sortIndex }
        return sortedDirection
    }
    
    
    init(for transportLine: MHD_TransportLine) {
        self.transportLine = transportLine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(transportLine:) instead. This controller doesn't support Storyboards.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        setupContent()
        setupDirectionButtonStack()
        setupRootStack()
    }

}

extension DirectionsViewController {
    
    private func setupContent() {
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupDirectionButtonStack() {
        let directionOneBtn = CustomButton(
            type: .textIcon(
                label: directions[0].endDestination?.stationName ?? "",
                textColor: .white,
                iconName: SFSymbols.arrowUpForward,
                iconColor: .white,
                iconSize: 20,
                spacing: 8
            ),
            style: .filled(
                backgroundColor: .systemBlue,
                cornerRadius: 0
            ),
            size: .auto(pTop: 16, pTrailing: 16, pBottom: 16, pLeading: 16)
        )
        directionOneBtn.onRelease = {
            self.moveToStations(for: self.directions[0])
        }
        
        
        let directionTwoBtn = CustomButton(
            type: .textIcon(
                label: directions[1].endDestination?.stationName ?? "",
                textColor: .white,
                iconName: SFSymbols.arrowDownLeft,
                iconColor: .white,
                iconSize: 20,
                spacing: 8
            ),
            style: .filled(
                backgroundColor: .systemBlue,
                cornerRadius: 0
            ),
            size: .auto(pTop: 16, pTrailing: 16, pBottom: 16, pLeading: 16)
        )
        directionTwoBtn.onRelease = {
            self.moveToStations(for: self.directions[1])
        }
        
        directionButtonStack.addArrangedSubview(directionOneBtn)
        directionButtonStack.addArrangedSubview(directionTwoBtn)
    }
    
    private func setupRootStack() {
        transportLineIdentificator.text = transportLine.name
        
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(rootStack)
        
        rootStack.addArrangedSubview(transportLineIdentificator)
        rootStack.addArrangedSubview(directionText)
        rootStack.addArrangedSubview(destinationIcon)
        rootStack.addArrangedSubview(directionButtonStack)

        
        
        NSLayoutConstraint.activate([
            rootStack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: horizontalPadding),
            rootStack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -horizontalPadding),
            rootStack.centerYAnchor.constraint(equalTo: content.centerYAnchor),
            
            directionButtonStack.leadingAnchor.constraint(equalTo: rootStack.leadingAnchor),
            directionButtonStack.trailingAnchor.constraint(equalTo: rootStack.trailingAnchor)
        ])
        
        rootStack.setCustomSpacing(16, after: transportLineIdentificator)
        
    }
    
}

extension DirectionsViewController {
    
    private func moveToStations(for direction: MHD_Direction) {
        let stationViewController = RouteStationsController(direction: direction)
        navigationController?.pushViewController(stationViewController, animated: true)
    }
    
}
