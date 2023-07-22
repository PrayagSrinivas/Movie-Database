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
  var errorMessage: String = ""
  var filterItems: [FilterModel] = []
  
  private var universalSubitemData: [FilterModel] = []
  private var filteredYear: [String] = []
  private var filteredGenre: [String] = []
  private var filteredDirectors: [String] = []
  private var filteredActors: [String] = []
  
  init() {
    loadData()
  }

  private func loadData() {
    do {
      // Load the JSON file from the main bundle.
      guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
        showError = true
        errorMessage = "Invalid JSON"
        return
      }

      // Try to load the data from the URL.
      let data = try Data(contentsOf: url)

      // Decode the JSON data into an array of MovieModel using Codable.
      let movies = try JSONDecoder().decode([MovieModel].self, from: data)

      // Assign the movies to the instance property.
      self.movies = movies

      // Extract years, genres, actors, and directors from movies.
      var years = [String]()
      var genres = [String]()
      var actors = [String]()
      var directors = [String]()

      for movie in movies {
        years.append(contentsOf: movie.year.components(separatedBy: "-"))
        genres.append(contentsOf: movie.genre.components(separatedBy: ", "))
        actors.append(contentsOf: movie.actors.components(separatedBy: ", "))
        directors.append(contentsOf: movie.director.components(separatedBy: ", "))
      }

      filteredYear =  years.removingDuplicates{$0.hashValue}.sorted{ $0 > $1}
      filteredGenre = genres.removingDuplicates{$0.hashValue}.sorted{ $0 < $1}
      filteredActors = actors.removingDuplicates{$0.hashValue}.sorted{ $0 < $1}
      filteredDirectors = directors.removingDuplicates{$0.hashValue}.sorted{ $0 < $1}

      // Finally, make dashboard filters.
      makeDashBoardFilters()

    } catch {
      // Catch any errors during the process and handle them appropriately.
      showError = true
      errorMessage = "Invalid JSON: \(error.localizedDescription)"
    }

  }
  
  private func makeDashBoardFilters() {
    for item in FilterType.allCases {
      filterItems.append(
        FilterModel(
          name: item.rawValue,
          image: item.rawValue,
          subMenuItems: makeSubItem(itemType: item)
        )
      )
    }
    filterItems.removeLast()
  }
  private func makeSubItem(itemType: FilterType) -> [FilterModel] {
    var data: [FilterModel] = []
    switch itemType {
    case .actors:
      filteredActors.forEach { item in
        data.append(FilterModel(name: item, isSubItem: true, filterType: .actors))
      }

    case .directors:
      filteredDirectors.forEach { item in
        data.append(FilterModel(name: item, isSubItem: true, filterType: .directors))
      }

    case .genre:
      filteredGenre.forEach { item in
        data.append(FilterModel(name: item, isSubItem: true, filterType: .genre))
      }

    case .year:
      filteredYear.forEach { item in
        data.append(FilterModel(name: item, isSubItem: true, filterType: .year))
      }
    case .allMovies:
      movies.sorted{$0.title < $1.title}.forEach { item in
        data.append(
          FilterModel(
            name: item.title,
            image: item.poster,
            presentAllMovies: true,
            releaseDate: item.released
          )
        )
      }
    default :
      break
    }

    return data
  }

  func makeFilteredList(
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

    default:
      break
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
