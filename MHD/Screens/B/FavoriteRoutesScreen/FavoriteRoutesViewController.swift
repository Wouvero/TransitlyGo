//
//
//
// Created by: Patrik Drab on 21/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit

class FavoriteRoutesViewController: UIViewController, MHD_NavigationDelegate {

    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Obľúbené", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
    }
}
