//
//  ContentView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-06.
//

import SwiftUI

struct ContentView: View {
    @State private var vm = ContentVM()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ColorSortPicker(selection: $vm.colorFilter)
                    .padding(.top, 24)
                    .padding(.bottom)
                Divider()
                NoteBoardView(vm: vm)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                BottomToolbar {
                    ViewTypeMenu(selected: vm.viewType) { viewType in
                        vm.setViewType(viewType)
                    }
                } trailing: {
                    CleanUpMenu { option in
                        vm.cleanUpOptionSelected(option)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(LocalKey.sticky)
                        .tracking(1.4)
                        .font(.system(.body, design: .serif, weight: .semibold))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NoteEditorLink.newEditor
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
