//
//  BottomToolbar.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct BottomToolbar<Leading: View, Trailing: View>: View {
    @ViewBuilder let leading: () -> Leading
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        VStack {
            Divider()
            HStack {
                leading()
                Spacer()
                trailing()
            }
            .padding()
        }
        .frame(height: 60)
        .background(Color.appBackground)
    }
}

#Preview {
    BottomToolbar {
        
    } trailing: {
        
    }
}
