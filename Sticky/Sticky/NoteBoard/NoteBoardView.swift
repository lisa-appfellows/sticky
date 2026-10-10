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
    @Bindable var contentVM: ContentVM

    @Query private var notes: [NoteModel]
    private let vm = NoteBoardVM()

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible()),
            count: vm.numOfColumns(for: contentVM.viewType)
        )
    }

    private var spacing: CGFloat {
        contentVM.viewType.noteSpacing
    }

    private var sortedNotes: [NoteModel] {
        vm.sorted(notes, by: contentVM.sortOption)
    }
    
    init(contentVM: ContentVM) {
        _notes = Query(
            filter: contentVM.predicate,
            sort: [SortDescriptor(\.sortOrder)]
        )
        _contentVM = Bindable(contentVM)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(sortedNotes, id: \.self) { note in

                    let dto = note.asDTO
                    NoteCardView(
                        dto: dto,
                        viewType: contentVM.viewType,
                        availableWidth: vm.availableCardWidth(for: screenSize)
                    )
                    .noteEditorSheet(.existing(dto))
    
                }
            }
            .padding(.horizontal, vm.horizontalPadding)
        }
        .safeAreaPadding(.top, 24)
    }
}

#if DEBUG
#Preview {
    SizingContainer {
        NavigationStack {
            NoteBoardView(
                contentVM: ContentVM(defaults: PreviewSupport.userDefaults)
            )
        }
    }
    .modelContainer(PreviewSupport.modelContainer)
}
#endif
