//
//  MovieDetailsView.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

struct MovieDetailsView: View {
  @State private var selectedRating: String = "-"
  @State private var selectedRatingSource: String = "Tap to select"
  
  var movie: MovieModel
  
  init(movie: MovieModel) {
    self.movie = movie
  }
  
  var body: some View {
    HStack() {
      posterViewWithMovieInfo
    }
    ScrollView {
      makePlotView()
    }
  }
  
  private var posterViewWithMovieInfo: some View {
    HStack() {
      AsyncImage(url: URL(string: movie.poster)){image in
        image.resizable()
      } placeholder: {
        Image("Placeholder")
          .frame(width: 150, height: 150)
          .background(Color.gray)
      }
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
      
      VStack(alignment: .leading) {
        makeMovieOverView(
          title: movie.title,
          actors: movie.actors,
          releaseDate: movie.released
        )
      }
      .padding()
    }
  }
  
  private func makeMovieOverView(
    title: String,
    actors: String,
    releaseDate: String
  ) -> some View {
    
    VStack(alignment: .leading, spacing: 3) {
      Text(title)
        .fontWeight(.black)
      VStack(alignment: .leading, spacing: 5) {
        Text("Cast & Crew:")
          .fontWeight(.semibold)
        Text(actors)
          .fontWeight(.regular)
      }
      VStack(alignment: .leading, spacing: 5) {
        Text("Releas Date:")
          .fontWeight(.semibold)
        Text(releaseDate)
      }
      VStack(alignment: .leading, spacing: 5) {
        Text("Rating:")
          .fontWeight(.semibold)
        makeRatingMenuView()
        Text(selectedRating)
      }
    }
  }
  
  private func makeRatingMenuView() -> some View {
    Menu {
      ForEach(movie.ratings, id: \.value) { item in
        Button(action: {
          selectedRating = item.value
          selectedRatingSource = item.source.rawValue
        }) {
          Text(item.source.rawValue)
        }
      }
    } label: {
      Text(selectedRatingSource)
    }
  }
  
  private func makePlotView() -> some View {
    VStack(alignment: .leading) {
      Text("Plot")
        .font(.title)
        .fontWeight(.semibold)
      Text(movie.plot)
        .font(.body)
    }
    .padding()
  }
}

