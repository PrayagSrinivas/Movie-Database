//
//  FilteredListView.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

struct FilteredListView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var dataForTheList: [MovieModel] = []
  
  var filterKey: String
  var filterType: FilterType
  
  init(filterKey: String, filterType: FilterType) {
    self.filterKey = filterKey
    self.filterType = filterType
  }
  
  var body: some View {
    List(dataForTheList) { item in
      HStack {
        Text(item.title)
        NavigationLink(destination: {
          MovieDetailsView(movie: item)
        }, label: {})
      }
    }
    .onAppear {
      dataForTheList = viewModel.createTheFilteredList(filterType: filterType, filterKey: filterKey)
    }
    
    .navigationTitle("Showing results for: \(filterKey) ")
    .navigationBarTitleDisplayMode(.inline)    
  }
}

