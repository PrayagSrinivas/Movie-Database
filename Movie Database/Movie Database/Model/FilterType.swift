//
//  FilterType.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import Foundation

enum FilterType: String, CaseIterable {
  case actors = "Actors"
  case directors = "Directors"
  case genre = "Genre"
  case year = "Year"
  case allMovies = "All Movies"
  case none
}
// TODO: Here As per filter requirement that we need to show on DashBoard and add the cases and handle on ViewModel .


