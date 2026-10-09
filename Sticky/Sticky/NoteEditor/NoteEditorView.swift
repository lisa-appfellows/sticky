//
//  NoteEditorView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

@MainActor
struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var vm: NoteEditorVM

    init(dto: NoteDTO? = nil) {
        _vm = State(initialValue: .init(dto: dto))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 18) {
                        ForEach(NoteColor.allCases, id: \.self) { noteColor in
                            Button {
                                vm.dto.noteColor = noteColor
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(noteColor.color)
                                    if vm.noteColorIsSelected(noteColor) {
                                        Image(systemName: SystemKey.checkmark)
                                            .foregroundStyle(.black)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowBackground(Color.clear)
                } header: {
                    Text(LocalKey.noteColor)
                }

                Section {
                    Group {
                        TextField(text: $vm.dto.title) {
                            Text(LocalKey.enterTitlePlaceholder)
                                .foregroundStyle(.appSecondary)
                        }
                        .noteFont(.mediumTitle)
                        TextField(text: $vm.dto.text, axis: .vertical) {
                            Text(LocalKey.enterTextPlaceholder)
                                .foregroundStyle(.appSecondary)
                        }
                        .lineLimit(15...28)
                        .noteFont(.mediumText)
                        Text(vm.dateString)
                            .font(.caption)
                            .foregroundStyle(.appSecondary)
                    }
                    .foregroundStyle(.black)
                    .listRowBackground(vm.rowBackgroundColor)
                } header: {
                    Text(LocalKey.note)
                }

                if vm.canDelete {
                    HStack {
                        Spacer()
                        Button(role: .destructive, action: { delete() }) {
                            HStack(spacing: 8) {
                                Image(systemName: SystemKey.trash)
                                Text(LocalKey.deleteNote)
                            }
                            .font(.footnote)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
            }
            .navigationTitle(Text(vm.navTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Text(LocalKey.cancel)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { save() }) {
                        Text(LocalKey.save)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func save() {
        // TODO: Save action
        dismiss()
    }

    private func delete() {
        // TODO: Delete note
        dismiss()
    }
}

#Preview("New Note") {
    NoteEditorView()
}

#Preview("Existing Note") {
    NoteEditorView(dto: PreviewSupport.sampleNoteDTO())
}
