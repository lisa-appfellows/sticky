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
                NoteBoardView(
                    contentVM: vm,
                    colorFilter: vm.colorFilter,
                    editorSheet: $vm.editorSheet
                )
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
                        .accessibilityAddTraits(.isHeader)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.editorSheet = .new(vm.colorFilter)
                    } label: {
                        Image(systemName: SystemKey.plus)
                            .accessibilityHidden(true)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(String(localized: LocalKey.createNote))
                }
            }
            .noteEditorSheet(item: $vm.editorSheet)
        }
    }
}

#Preview {
    SizingContainer {
        ContentView()
    }
    .modelContainer(PreviewSupport.modelContainer)
}
