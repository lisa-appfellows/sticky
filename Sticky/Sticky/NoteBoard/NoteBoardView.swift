//
//  NoteBoardView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import SwiftUI

struct NoteBoardView: View {
    @Environment(\.screenSize) private var screenSize
    @Bindable var vm: ContentVM
    @Query private var notes: [NoteModel]

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible()),
            count: vm.viewType == .grid ? 2 : 1
        )
    }

    private let boardPadding: CGFloat = 16
    private var availableCardWidth: CGFloat {
        screenSize.width - (boardPadding * 2)
    }
    
    init(vm: ContentVM) {
        _notes = Query(
            filter: vm.predicate,
            sort: [SortDescriptor(\.sortOrder)]
        )
        _vm = Bindable(vm)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: vm.viewType.noteSpacing) {
                ForEach(notes, id: \.self) { note in

                    let dto = note.asDTO
                    NoteCardView(
                        dto: dto,
                        viewType: vm.viewType,
                        availableWidth: availableCardWidth
                    )
                    .noteEditorSheet(.existing(dto))
    
                }
            }
            .padding(.horizontal, boardPadding)
        }
        .safeAreaPadding(.top, 24)
    }
}

#if DEBUG
#Preview {
    SizingContainer {
        NavigationStack {
            NoteBoardView(
                vm: ContentVM(defaults: PreviewSupport.userDefaults)
            )
        }
    }
    .modelContainer(PreviewSupport.modelContainer)
}
#endif
