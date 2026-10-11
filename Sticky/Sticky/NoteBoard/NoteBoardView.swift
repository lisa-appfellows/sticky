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
    @Binding var editorSheet: NoteEditorSheet?

    @Query private var notes: [NoteModel]
    private let layout = NoteBoardLayout()

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible()),
            count: layout.numOfColumns(for: contentVM.viewType)
        )
    }

    private var spacing: CGFloat {
        contentVM.viewType.noteSpacing
    }

    private var sortedNotes: [NoteModel] {
        layout.sorted(notes, by: contentVM.sortOption)
    }

    init(
        contentVM: ContentVM,
        colorFilter: NoteColor?,
        editorSheet: Binding<NoteEditorSheet?>
    ) {
        _contentVM = Bindable(contentVM)
        _editorSheet = editorSheet

        let predicate: Predicate<NoteModel>?
        if let colorFilterName = colorFilter?.rawValue {
            predicate = #Predicate { $0.noteColorName == colorFilterName }
        } else {
            predicate = nil
        }

        _notes = Query(
            filter: predicate,
            sort: [SortDescriptor(\.sortOrder)]
        )
    }

    var body: some View {
        if sortedNotes.isEmpty {
            EmptyNotesView(
                noteColor: contentVM.colorFilter,
                editorSheet: $editorSheet
            )
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(sortedNotes, id: \.self) { note in
                        NoteCardView(
                            dto: note.asDTO,
                            viewType: contentVM.viewType,
                            availableWidth: layout.availableCardWidth(for: screenSize),
                            editorSheet: $editorSheet
                        )
                    }
                }
                .padding(.horizontal, layout.horizontalPadding)
            }
            .safeAreaPadding(.top, 24)
        }
    }
}

#if DEBUG
#Preview {
    SizingContainer {
        NavigationStack {
            NoteBoardView(
                contentVM: ContentVM(defaults: PreviewSupport.userDefaults),
                colorFilter: nil,
                editorSheet: .constant(nil)
            )
        }
    }
    .modelContainer(PreviewSupport.modelContainer)
}
#endif
