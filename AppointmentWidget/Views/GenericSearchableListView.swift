//
//  GenericSearchableListView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 15/07/25.
//


import SwiftUI

struct GenericSearchableListView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable & Hashable, Content: View {
    let data: Data
    let rowContent: (Data.Element) -> Content
    let filter: (Data.Element, String) -> Bool
    let searchPlaceholder: String

    @State private var searchText = ""
    @State private var isSearching: Bool = false

    var filteredData: [Data.Element] {
        if searchText.isEmpty {
            return Array(data)
        } else {
            return data.filter { filter($0, searchText) }
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: searchPlaceholder, debounceTime: 0.3)
            List(filteredData) { item in
                rowContent(item)
            }
        }
    }
}

struct User: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let email: String
}

let users = [
    User(name: "Alice", email: "alice@example.com"),
    User(name: "Bob", email: "bob@example.com"),
    User(name: "Charlie", email: "charlie@example.com")
]

#Preview {
        GenericSearchableListView(
            data: users,
            rowContent: { user in
                VStack(alignment: .leading) {
                    Text(user.name).font(.headline)
                    Text(user.email).font(.subheadline).foregroundColor(.gray)
                }
            },
            filter: { user, query in
                user.name.lowercased().contains(query.lowercased()) ||
                user.email.lowercased().contains(query.lowercased())
            },
            searchPlaceholder: "Enter name or email"
        )
    .environmentObject(Navigator())
}
