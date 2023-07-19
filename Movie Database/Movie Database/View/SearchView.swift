//
//  SearchView.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

struct SearchView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var searchInput: String = ""
  
  var body: some View {
    NavigationStack {
      List(searchResults) { item in
        HStack{
          Text(item.title)
          NavigationLink {
            MovieDetailsView(movie: item)
          } label: {}
        }
      }
      .navigationTitle("Search Movie")
    }
    .searchable(
      text: $searchInput,
      prompt: Text("Search movie with actors/directors/genre/year")
    )
  }
  var searchResults: [MovieModel] {
    if searchInput.isEmpty {
      return viewModel.movies
    } else {
      return viewModel.movies.filter {
        $0.actors.contains(searchInput) ||
        $0.title.contains(searchInput) ||
        $0.director.contains(searchInput) ||
        $0.genre.contains(searchInput) ||
        $0.year.contains(searchInput)}
    }
  }
  
}
