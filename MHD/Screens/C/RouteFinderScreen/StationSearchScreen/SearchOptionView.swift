//
//
//
// Created by: Patrik Drab on 31/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro

struct Option {
    let iconName: String
    let optionText: String
    let viewControllerProvider: () -> UIViewController?
}

extension Option {
    static let options: [Option] = [
        Option(
            iconName: "flag.fill",
            optionText: "Zo zoznamu všetkých",
            viewControllerProvider: { AllStationsListViewController() }
        ),
//        Option(
//            iconName: "location.fill",
//            optionText: "Z najbližších podľa polohy",
//            viewControllerProvider: { nil }
//        ),
        Option(
            iconName: "map.fill",
            optionText: "Na mape",
            viewControllerProvider: { MapViewController() }
        )
    ]
}

class SearchOptionsView: UIView {
    
    weak var viewModel: RouteFinderViewModel?
    var fieldType: InputFieldType = .from
    
    private let content = UIStackView(
        axis: .vertical,
        spacing: 0,
        alignment: .center,
        distribution: .fill
    )
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            content.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            content.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        ])
        
        let optionStack = UIStackView(
            axis: .vertical,
            spacing: 16,
            alignment: .fill,
            distribution: .fill
        )
        
        for option in Option.options {
            optionStack.addArrangedSubview(makeStackOptionRow(option: option))
        }
        
        content.addArrangedSubview(optionStack)

    }
    
    private func makeStackOptionRow(option: Option) -> UIStackView {
        let label = UILabel(
            text: option.optionText,
            font: UIFont.interMedium(size: 16),
            textColor: .neutral800,
            textAlignment: .left,
            numberOfLines: 1
        )
        
        let icon = IconImageView(systemName: option.iconName, color: .neutral800)
        
        let row = UIStackView(
            arrangedSubviews: [
                icon,
                label,
                UIView()
            ],
            axis: .horizontal,
            spacing: 8,
            alignment: .fill,
            distribution: .fill
        )
        row.isLayoutMarginsRelativeArrangement = true
        row.layoutMargins.left = 16
        row.layoutMargins.right = 16
        row.layoutMargins.top = 8
        row.layoutMargins.bottom = 8
        
        row.onTapGesture { [weak self] in
            guard let self else { return }
            
            guard let optionViewController = option.viewControllerProvider(),
                  let vc = self.findViewController() else { return }
            
            if let stationListVC = optionViewController as? AllStationsListViewController {
                stationListVC.fieldType = fieldType
                stationListVC.viewModel = viewModel
                vc.navigate(to: stationListVC, animation: true)
            }
            if let mapVC = optionViewController as? MapViewController {
                mapVC.fieldType = fieldType
                vc.navigate(to: mapVC, animation: true)

            }
        }
        return row
    }
}
