//
//  TestSupport.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation
import XCTest

enum TestSupport {
    static let gregorianCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    static let updatedDate = createDate(year: 2026, month: 6, day: 8, hour: 10, minute: 30, second: 50)
    static let updatedDateString = updatedDate.ISO8601Format()
    
    static func createDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int
    ) -> Date {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        comps.hour = hour
        comps.minute = minute
        comps.second = second
        return gregorianCalendar.date(from: comps)!
    }

    static func sameDay(_ dateA: Date, as dateB: Date) -> Bool {
        gregorianCalendar.isDate(dateA, equalTo: dateB, toGranularity: .day)
    }

    static func sameDay(dateString: String, asDate dateB: Date) throws -> Bool {
        let dateA = try XCTUnwrap(ISO8601DateFormatter().date(from: dateString))
        return sameDay(dateA, as: dateB)
    }
}
