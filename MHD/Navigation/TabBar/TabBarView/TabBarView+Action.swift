//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


extension TabBarView {
    // MARK: - Actions
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        updateSelectedItem(to: view.tag)
        delegate?.didTapItem(at: view.tag)
    }
}
