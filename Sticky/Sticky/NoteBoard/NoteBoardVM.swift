//
//  NoteBoardVM.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-10.
//

import Foundation

struct NoteBoardVM {
    let horizontalPadding: CGFloat = 16

    func numOfColumns(for viewType: ViewType) -> Int {
        switch viewType {
        case .grid: return 2
        default: return 1
        }
    }

    func availableCardWidth(for screenSize: CGSize) -> CGFloat {
        screenSize.width - (horizontalPadding * 2)
    }

    func sorted(_ notes: [NoteModel], by option: SortOption) -> [NoteModel] {
        switch option {
        case .newest:
            return sortByDate(notes, isNewest: true)
        case .oldest:
            return sortByDate(notes, isNewest: false)
        case .name:
            return sortByName(notes)
        }
    }

    private func sortByName(_ notes: [NoteModel]) -> [NoteModel] {
        notes.sorted {
            switch (($0.title ?? $0.text), ($1.title ?? $1.text)) {
            case let (a?, b?) where a != b:
                return a.localizedStandardCompare(b) == .orderedAscending
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            default:
                return ($0.sortOrder ?? -1) < ($1.sortOrder ?? -1)
            }
        }
    }

    private func sortByDate(_ notes: [NoteModel], isNewest: Bool) -> [NoteModel] {
        notes.sorted {
            switch ($0.updatedString, $1.updatedString) {
            case let (a?, b?) where a != b:
                return isNewest ? a > b : a < b
            case (_?, nil) :
                return true
            case (nil, _?):
                return false
            default:
                return ($0.sortOrder ?? -1) < ($1.sortOrder ?? -1)
            }
        }
    }
}
