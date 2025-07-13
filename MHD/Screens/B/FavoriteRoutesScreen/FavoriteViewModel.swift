//
//
//
// Created by: Patrik Drab on 13/07/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI


class FavoriteViewModel: ObservableObject {
    @Published var favorites: [MHD_Favorite] = []
    
    private let context = MHD_CoreDataManager.shared.viewContext
    
    init() {
        fetchFavorites()
        setupNotificationObserver()
    }
    
    func fetchFavorites() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            favorites = MHD_Favorite.getAll(in: context)
        }
    }
    
    func handleDeleteFromFavorites(_ item: MHD_Favorite?) {
        guard let item else { return }
        MHD_Favorite.delete(item, in: context)
    }
    
    @discardableResult
    func handleUpdateFavorite(_ item: MHD_Favorite, newName: String) -> Bool {
        guard item.name != newName else { return false }
        item.name = newName
        return MHD_Favorite.update(item, in: context)
    }
    
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.fetchFavorites()
        }
    }
}
