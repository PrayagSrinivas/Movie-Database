//
//  ViewModel.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

class ViewModel: ObservableObject {
  @Published var movies = [MovieModel]()
  
  var filterItems: [FilterModel] = []
  
  var yearSubItemData: [FilterModel] = []
  var actorSubItemData: [FilterModel] = []
  var directorSubItemData: [FilterModel] = []
  var genreSubItemData: [FilterModel] = []
  
  var filteredYear: [String] = []
  var filteredGenre: [String] = []
  var filteredDirectors: [String] = []
  var filteredActors: [String] = []
  
  init() {
    loadDataAndMakeFilters()
  }
  
  private func loadDataAndMakeFilters(){
    guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
      print("Json file not found")
      return
    }
    
    let data = try? Data(contentsOf: url)
    let movies = try? JSONDecoder().decode([MovieModel].self, from: data!)
    if let movies = movies {
      self.movies = movies
    }
    do {
      filterAll()
    }
  }
  
  private func createFilters() {
    filteredGenre.removingDuplicates{ $0.hashValue }.forEach { genre in
      genreSubItemData.append(
        FilterModel(
          name: genre,
          isSubItem: true,
          filterType: .genre
        )
      )
    }
    filteredActors.removingDuplicates{ $0.hashValue }.forEach { act in
      actorSubItemData.append(
        FilterModel(
          name: act,
          isSubItem: true,
          filterType: .actors
        )
      )
    }
    filteredDirectors.removingDuplicates{ $0.hashValue }.forEach { director in
      directorSubItemData.append(
        FilterModel(
          name: director,
          isSubItem: true,
          filterType: .directors
        )
      )
    }
    filteredYear.removingDuplicates{ $0.hashValue }.forEach { year in
      yearSubItemData.append(
        FilterModel(
          name: year,
          isSubItem: true,
          filterType: .year
        )
      )
    }
    
    filterItems = [
      FilterModel(
        name: "Year",
        image: "Year",
        subMenuItems: yearSubItemData.sorted{$0.name > $1.name}
      ),
      FilterModel(
        name: "Genre",
        image: "Genre",
        subMenuItems: genreSubItemData.sorted{$0.name < $1.name}
      ),
      FilterModel(
        name: "Directors",
        image: "Director",
        subMenuItems: directorSubItemData.sorted{$0.name < $1.name}
      ),
      FilterModel(
        name: "Actors",
        image: "Actor",
        subMenuItems: actorSubItemData.sorted{$0.name < $1.name}
      )
    ]
  }
  
  private func filterAll() {
    movies.forEach { item in
      filteredGenre += Array(Set(item.genre.components(separatedBy: ", ")))
      filteredDirectors += Array(Set(item.director.components(separatedBy: ", ")))
      filteredActors += Array(Set(item.actors.components(separatedBy: ", ")))
      filteredYear += Array(Set(item.year.components(separatedBy: "-")))
    }
    do {
      createFilters()
    }
  }
  
  func createTheFilteredList(
    filterType: FilterType,
    filterKey: String
  ) -> [MovieModel] {
    var data: [MovieModel] = []
    
    switch filterType {
    case .actors:
      data = self.movies.filter {$0.actors.contains(filterKey)}
    case .directors:
      data = self.movies.filter {$0.director.contains(filterKey)}
      
    case .genre:
      data = self.movies.filter {$0.genre.contains(filterKey)}
      
    case .year:
      data = self.movies.filter {$0.year.contains(filterKey)}
      
    case .none:
      data = []
    }
    
    return data
  }
}
