//
//
//
// Created by: Patrik Drab on 13/07/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI


struct FavoriteView: View {
    
    @ObservedObject var vm: FavoriteViewModel
    var onItemTap: (MHD_Favorite) -> Void
    
    let data: [MHD_Favorite] = []
    
    @State private var showTextFieldAlert = false
    @State private var showSystemAlert = false
    @State private var selectedItem: MHD_Favorite?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(vm.favorites, id:\.self) { item in
                    FavoriteItem(
                        item: item,
                        vm: vm,
                        showTextFieldAlert: $showTextFieldAlert,
                        showSystemAlert: $showSystemAlert,
                        selectedItem: $selectedItem,
                        onTap: { onItemTap(item) }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(.neutral10)
        .textFieldAlert(
            isPresented: $showTextFieldAlert,
            title: "Názov obľúbenej položky",
            message: "Napr. Do práce. K rodičom, atď...",
            text: selectedItem?.name ?? "",
            affirmativeAction: { updatedText in
                guard let selectedItem, let updatedText else { return }
                showTextFieldAlert = !vm.handleUpdateFavorite(selectedItem, newName: updatedText)
            },
            dismissiveAction: {
                showTextFieldAlert = false
            }
        )
        .systemAlert(
            isPresented: $showSystemAlert,
            title: selectedItem?.name,
            message: "Naozaj chcete vymazať tuto obľúbenú položku?",
            affirmativeAction: {
                vm.handleDeleteFromFavorites(selectedItem)
                showSystemAlert = false
            },
            dismissiveAction: {
                showSystemAlert = false
            }
        )
    }
}
