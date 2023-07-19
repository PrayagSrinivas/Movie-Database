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
  
    var body: some View {
      NavigationView {
        List(movieData.filterItems, children: \.subMenuItems) { item in
          HStack {
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
        }
        .sheet(isPresented: $presentSearchScreenSheet, content: {
          SearchView()
        })
        .navigationTitle("Movie Database")
        .toolbar {
          Button {
            presentSearchScreenSheet = true
          } label: {
            Image(systemName: "magnifyingglass")
          }
        }
      }
      .environmentObject(movieData)
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
