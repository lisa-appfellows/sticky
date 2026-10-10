//
//  NoteEditorView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

@MainActor
struct NoteEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var vm: NoteEditorVM
    @FocusState private var focusField: EditorField?

    init(dto: NoteDTO) {
        _vm = State(initialValue: .init(dto: dto))
    }

    init(noteColor: NoteColor?) {
        _vm = State(initialValue: .init(noteColor: noteColor))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NoteColorSelector(selection: $vm.dto.noteColor)
                        .listRowBackground(Color.clear)
                } header: {
                    Text(LocalKey.noteColor)
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        TitleField(
                            LocalKey.enterTitlePlaceholder,
                            text: $vm.dto.title,
                            focusBinding: $focusField
                        )
                        Divider()
                        BodyEditor(
                            LocalKey.enterTextPlaceholder,
                            text: $vm.dto.text,
                            focusBinding: $focusField
                        )
                        Divider()
                        Text(vm.dateString)
                            .font(.caption)
                            .foregroundStyle(.appSecondary)
                            .padding(.bottom, 8)
                    }
                    .foregroundStyle(.black)
                    .listRowBackground(vm.rowBackgroundColor)
                } header: {
                    HStack {
                        Text(LocalKey.note)
                        Spacer()
                        if focusField != nil {
                            doneButton
                        }
                    }
                    .frame(height: 25)
                }

                if vm.canDelete {
                    deleteNoteView
                        .listRowBackground(Color.clear)
                }
            }
            .onChange(of: vm.shouldDismiss) { _, shouldDismiss in
                if shouldDismiss { dismiss() }
            }
            .navigationTitle(Text(vm.navTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(LocalKey.cancel)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        vm.save(to: context)
                    } label: {
                        Text(LocalKey.save)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .failedOperationAlert(
            isPresented: $vm.shouldShowAlert,
            title: vm.failedOperationTitle,
            retryAction: { vm.retryOperation(context: context) },
            cancelAction: { vm.cancelOperation() }
        )

    }

    private var doneButton: some View {
        Button {
            focusField = nil
        } label: {
            Text(LocalKey.done)
                .textCase(.none)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        }
    }

    private var deleteNoteView: some View {
        HStack {
            Spacer()
            Button(role: .destructive) {
                vm.delete(from: context)
            } label: {
                HStack {
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
    }
}

#Preview("New Note") {
    NoteEditorView(noteColor: .yellow)
}

#Preview("Existing Note") {
    NoteEditorView(dto: PreviewSupport.sampleNoteDTO())
}
