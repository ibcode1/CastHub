//
//  CHTab.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 21/12/2025.
//

import Foundation

enum CHTab: Int, CaseIterable, Identifiable {
    case search, save

    var id: Self { self }
    var tag: Int? { rawValue }
    
    var title: String {
        switch self {
        case .search:    return "Search"
        case .save:      return "Save"
        }
    }
    var icon: String {
        switch self {
        case .search:   return "magnifyingglass"
        case .save:     return "arrow.down.circle"
        }
    }
}


