//
//
//
// Created by: Patrik Drab on 17/06/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        ZStack {
            Color.primary500.ignoresSafeArea()
            Image("time-line")
                .font(.system(size: 48))
                .imageScale(.large)
                .foregroundStyle(.neutral)
        }
    }
}

struct WelcomePreviewProvider: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .ignoresSafeArea()
    }
}
