//
//  FilterModel.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import Foundation

struct FilterModel: Identifiable {
    var id = UUID()
    var name: String
    var image: String?
    var subMenuItems: [FilterModel]?
    var isSubItem: Bool = false
    var filterType: FilterType?
}
