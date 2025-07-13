//
//
//
// Created by: Patrik Drab on 13/07/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI


struct FavoriteItem: View {
    let item: MHD_Favorite
    let vm: FavoriteViewModel
    @Binding var showTextFieldAlert: Bool
    @Binding var showSystemAlert: Bool
    @Binding var selectedItem: MHD_Favorite?
    
    var onTap: (() -> Void)?
    
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    private let buttonWidth: CGFloat = 50
    
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                edditButton
                deleteButton
            }
            
            foregroundContent
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged{ gesture in
                            let newOffset = lastOffsetX + gesture.translation.width
                            
                            // Clamp the value between -buttonWidth and 0
                            offsetX = min(0, max(-buttonWidth*2, newOffset))
                        }
                        .onEnded{ gesture in
                            lastOffsetX = offsetX
                            
                            // Snap to nearest position
                            if offsetX < -100 * 0.75 {
                                offsetX = -100 // Fully open
                            } else if offsetX < -100 * 0.25 {
                                offsetX = -buttonWidth // Half open
                            } else {
                                offsetX = 0 // Closed
                            }
                            
                            lastOffsetX = offsetX // Store final position
                        }
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .animation(.spring(), value: offsetX)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.neutral.opacity(0.5))
                .stroke(.neutral600.opacity(0.7), lineWidth: 1)
        )
        .onTapGesture {
            onTap?()
        }
    }
    
    
    private var deleteButton: some View {
        Button {
            showSystemAlert = true
            selectedItem = item
        } label: {
            Image(SFSymbols.delete_bin_fill)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.danger700)
                .frame(width: buttonWidth)
                .frame(maxHeight: .infinity)
                .background(.danger200)
        }
    }
    
    private var edditButton: some View {
        Button {
            withAnimation(.spring()) {
                offsetX = 0
                lastOffsetX = 0
            }
            showTextFieldAlert = true
            selectedItem = item
        } label: {
            Image(SFSymbols.pencil_fill)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.warning700)
                .frame(width: buttonWidth)
                .frame(maxHeight: .infinity)
                .background(.warning200)
        }
    }
    
    private var foregroundContent: some View {
        HStack {
            Image(SFSymbols.search_line) // Your custom SVG asset name
                .resizable()
                .renderingMode(.template) // To allow tinting
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .foregroundColor(.neutral700) // or your danger700
            VStack {
                if let name = item.name {
                    HStack {
                        Text(name)
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }
                }
                HStack(alignment: .center) {
                    Image(SFSymbols.arrow_right_up_line)
                        .resizable()
                        .renderingMode(.template) // To allow tinting
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.neutral700)
                    if let stationName = item.fromStation {
                        Text(stationName)
                    }
                    Spacer()
                }
                HStack(alignment: .center) {
                    Image(SFSymbols.arrow_left_down_line)
                        .resizable()
                        .renderingMode(.template) // To allow tinting
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.neutral700)
                    if let stationName = item.toStation {
                        Text(stationName)
                    }
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(.neutral)
        )
        .foregroundStyle(.neutral600)
    }
}
