//
//  Int-DateHelpers.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 15/12/2025.
//

import Foundation

extension Int {
    nonisolated var millisecondsToDate: Date {

        let interval = TimeInterval(self)
        let date     = Date(timeIntervalSince1970: interval / 1000)
        return date
    }

    nonisolated var toDate: Date {
        let interval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: interval / 1000)
        return date
    }

    nonisolated func formattedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let date = self.toDate

        return formatter.string(from: date.timeIntervalSince1970) ?? "--:--:--"
    }
}
