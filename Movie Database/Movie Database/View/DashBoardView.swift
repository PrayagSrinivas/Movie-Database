//
//  DashBoardView.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

struct DashBoardView: View {
  @StateObject var movieData = ViewModel()
  @State private var presentSearchScreenSheet: Bool = false
  @State private var showError: Bool = true
  
  var body: some View {
    NavigationView {
      List(movieData.filterItems, children: \.subMenuItems) { item in
        if item.presentAllMovies {
          allMovieListCellView(item)
        } else {
          filterRowView(item)
        }
      }
      .animation(.easeIn)
      .sheet(isPresented: $presentSearchScreenSheet, content: {
        SearchView()
      })
      .alert(movieData.errorMessage, isPresented: $showError) {
          Button("OK", role: .cancel) { }
      }
      .listStyle(.plain)
      .navigationTitle("Movie Database")
      .toolbar {
        Button {
          presentSearchScreenSheet = true
        } label: {
          Image(systemName: "magnifyingglass")
        }
      }
    }
    .onAppear {
      showError = movieData.showError
    }
    .environmentObject(movieData)
  }
  @ViewBuilder
  private func allMovieListCellView(_ item: FilterModel) -> some View {
    if item.presentAllMovies {
      HStack {
        AsyncImage(url: URL(string: item.image ?? "")){image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          Image("Placeholder")
            .frame(width: 30, height: 30)
            .background(Color.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(width: 30, height: 30)
        .clipShape(RoundedRectangle(cornerRadius: 3))
        VStack(alignment: .leading) {
          Text(item.name)
            .fontWeight(.semibold)
          HStack {
            Text("Release Data:")
              .fontWeight(.medium)
            Text(item.releaseDate ?? "")
          }
        }
      }
      .padding(.horizontal, 5)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      .background(Color.gray.opacity(0.2))
      .cornerRadius(5)
    }
  }
  
  private func filterRowView(_ item: FilterModel) -> some View {
    HStack() {
      getImage(imageName: item.image)
      Text(item.name)
      if item.isSubItem {
        NavigationLink {
          FilteredListView(
            filterKey: item.name,
            filterType: item.filterType ?? .none
          )
        } label: { }
      }
    }
    .padding(.horizontal, item.isSubItem ? 10 : 10)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .background(item.isSubItem ? .blue.opacity(0.7) : .white)
    .foregroundColor(item.isSubItem ? .white : .black)
    .cornerRadius(item.isSubItem ? 5 : 0)
  }
  
  func getImage(imageName: String?) -> AnyView {
    if let name = imageName {
      return AnyView(
        Image(name)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 35, height: 35)
      )
    } else {
      return AnyView(
        EmptyView()
          .frame(width: 30, height: 30)
      )
    }
  }
}
