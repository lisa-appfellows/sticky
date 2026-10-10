//
//  ContentView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-06.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var vm = ContentVM()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ColorSortPicker(selection: $vm.colorFilter)
                    .padding(.top, 24)
                    .padding(.bottom)
                Divider()
                NoteBoardView(contentVM: vm)
                    .id(vm.colorFilter)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                BottomToolbar {
                    ViewTypeMenu(selection: $vm.viewType)
                } trailing: {
                    SortOptionMenu(selection: $vm.sortOption)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(LocalKey.sticky)
                        .tracking(1.4)
                        .font(.system(.body, design: .serif, weight: .semibold))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: SystemKey.plus)
                        .noteEditorSheet(.new(vm.colorFilter))
                }
            }
        }
    }
}

#Preview {
    SizingContainer {
        ContentView()
    }
    .modelContainer(PreviewSupport.modelContainer)
}
