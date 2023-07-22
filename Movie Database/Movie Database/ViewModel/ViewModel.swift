//
//  ViewModel.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

class ViewModel: ObservableObject {
  @Published var movies = [MovieModel]()
  var showError: Bool = false
  
  var filterItems: [FilterModel] = []
  var errorMessage: String = ""
  
  var yearSubItemData: [FilterModel] = []
  var actorSubItemData: [FilterModel] = []
  var directorSubItemData: [FilterModel] = []
  var genreSubItemData: [FilterModel] = []
  var universalSubItemData: [FilterModel] = []
  
  var filteredYear: [String] = []
  var filteredGenre: [String] = []
  var filteredDirectors: [String] = []
  var filteredActors: [String] = []
  
  
  init() {
    loadDataAndMakeFilters()
  }
  
  private func loadDataAndMakeFilters(){
    guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
      showError = true
      errorMessage = "Invalid JSON"
      return
    }
    
    let data = try? Data(contentsOf: url)
    let movies = try? JSONDecoder().decode([MovieModel].self, from: data!)
    guard let movies = movies else {
      showError = true
      errorMessage = "Invalid JSON"
      return
    }
    self.movies = movies
    do {
      filterAll()
    }
  }
  
  private func makeSubFilterModels() {
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
    movies.sorted{$0.title < $1.title}.forEach { item in
      universalSubItemData.append(
        FilterModel(
          name: item.title,
          image: item.poster,
          presentAllMovies: true,
          releaseDate: item.released
        )
      )
    }
    do {
      makeFilterModels()
    }
  }
  
  private func makeFilterModels() {
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
        image: "Directors",
        subMenuItems: directorSubItemData.sorted{$0.name < $1.name}
      ),
      FilterModel(
        name: "Actors",
        image: "Actors",
        subMenuItems: actorSubItemData.sorted{$0.name < $1.name}
      ),
      FilterModel(
        name: "All Movies",
        image: "All Movies",
        subMenuItems: universalSubItemData
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
      makeSubFilterModels()
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
  
  private func networkCall() {
    let url = ""
    //TODO: Actual URL will be added here.
    guard let url = URL(string: url) else { return }
    URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
      guard let self else { return }
      
      if let data = data {
        do {
          let decodedData = try JSONDecoder().decode([MovieModel].self, from: data)
          self.movies = decodedData
        } catch {
          showError = true
          errorMessage = "Error decoding JSON: \(error.localizedDescription)"
        }
      } else if let error = error {
        showError = true
        errorMessage = "Error decoding JSON: \(error.localizedDescription)"
      }
    }.resume()
  }
}
