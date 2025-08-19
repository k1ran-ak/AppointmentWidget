////
////  GenericListView.swift
////  AppointmentWidget
////
////  Created by Anush Kiran on 10/07/25.
////
//
//import SwiftUI
//
///// A generic list view with search functionality
///// T: The type of items in the list
///// V: The view type for each item
//struct GenericListView<T, V: View>: View {
//    @State private var searchText = ""
//    @State private var isSearching = false
//    
//    let items: [T]
//    let searchPredicate: (T, String) -> Bool
//    let itemView: (T) -> V
//    let emptyStateView: (() -> AnyView)?
//    let searchPlaceholder: String
//    let idProvider: (T) -> AnyHashable
//    
//    // MARK: - Computed Properties
//    
//    private var filteredItems: [T] {
//        if searchText.isEmpty {
//            return items
//        } else {
//            return items.filter { item in
//                searchPredicate(item, searchText)
//            }
//        }
//    }
//    
//    // MARK: - Initializers
//    
//    /// Initialize with required parameters
//    /// - Parameters:
//    ///   - items: Array of items to display
//    ///   - idProvider: Hashable id
//    ///   - searchPredicate: Closure that determines if an item matches the search text
//    ///   - itemView: Closure that creates the view for each item
//    ///   - searchPlaceholder: Placeholder text for the search bar
//    ///   - emptyStateView: Optional view to show when no items match the search
//    init(
//        items: [T],
//        idProvider: @escaping (T) -> AnyHashable,
//        searchPredicate: @escaping (T, String) -> Bool,
//        @ViewBuilder itemView: @escaping (T) -> V,
//        searchPlaceholder: String = "Search...",
//        emptyStateView: (() -> AnyView)? = nil
//    ) {
//        self.items = items
//        self.idProvider = idProvider
//        self.searchPredicate = searchPredicate
//        self.itemView = itemView
//        self.searchPlaceholder = searchPlaceholder
//        self.emptyStateView = emptyStateView
//    }
//    
//    // MARK: - Body
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Search Bar
//            searchBar
//            
//            // List Content
//            listContent
//        }
//        .navigationBarHidden(true)
//    }
//    
//    // MARK: - Search Bar
//    
//    private var searchBar: some View {
//        HStack {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.gray)
//                
//                TextField(searchPlaceholder, text: $searchText)
//                    .textFieldStyle(PlainTextFieldStyle())
//                    .onTapGesture {
//                        isSearching = true
//                    }
//                
//                if !searchText.isEmpty {
//                    Button(action: {
//                        searchText = ""
//                        isSearching = false
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding(.horizontal, 12)
//            .padding(.vertical, 8)
//            .background(Color(.systemGray6))
//            .cornerRadius(10)
//            
//            if isSearching {
//                Button("Cancel") {
//                    searchText = ""
//                    isSearching = false
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }
//                .foregroundColor(.blue)
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 8)
//        .background(Color(.systemBackground))
//    }
//    
//    // MARK: - List Content
//    
//    private var listContent: some View {
//        Group {
//            if filteredItems.isEmpty {
//                if let emptyStateView = emptyStateView {
//                    emptyStateView()
//                } else {
//                    defaultEmptyStateView
//                }
//            } else {
//                List(filteredItems, id: idProvider) { item in
//                    itemView(item)
//                }
//                .listStyle(PlainListStyle())
//            }
//        }
//    }
//    
//    // MARK: - Default Empty State
//    
//    private var defaultEmptyStateView: some View {
//        VStack(spacing: 16) {
//            Image(systemName: searchText.isEmpty ? "tray" : "magnifyingglass")
//                .font(.system(size: 50))
//                .foregroundColor(.gray)
//            
//            Text(searchText.isEmpty ? "No Items" : "No Results Found")
//                .font(.title2)
//                .fontWeight(.medium)
//                .foregroundColor(.primary)
//            
//            Text(searchText.isEmpty ? "Items will appear here when available." : "Try adjusting your search terms.")
//                .font(.body)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 32)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemGroupedBackground))
//    }
//}
//
//// MARK: - Convenience Initializers
//
//extension GenericListView {
//    /// Convenience initializer for string-based search
//    /// - Parameters:
//    ///   - items: Array of items to display
//    ///   - searchKeyPath: KeyPath to the string property to search in
//    ///   - itemView: Closure that creates the view for each item
//    ///   - searchPlaceholder: Placeholder text for the search bar
//    ///   - emptyStateView: Optional view to show when no items match the search
//    init<S: StringProtocol>(
//        items: [T],
//        searchKeyPath: KeyPath<T, S>,
//        @ViewBuilder itemView: @escaping (T) -> V,
//        searchPlaceholder: String = "Search...",
//        emptyStateView: (() -> AnyView)? = nil
//    ) where T: Hashable {
//        self.init(
//            items: items,
//            idProvider: { item in
//                item.hashValue
//            },
//            searchPredicate: { item, searchText in
//                item[keyPath: searchKeyPath].localizedCaseInsensitiveContains(searchText)
//            },
//            itemView: itemView,
//            searchPlaceholder: searchPlaceholder,
//            emptyStateView: emptyStateView
//        )
//    }
//    
//    /// Convenience initializer for multiple string properties search
//    /// - Parameters:
//    ///   - items: Array of items to display
//    ///   - searchKeyPaths: Array of KeyPaths to string properties to search in
//    ///   - itemView: Closure that creates the view for each item
//    ///   - searchPlaceholder: Placeholder text for the search bar
//    ///   - emptyStateView: Optional view to show when no items match the search
//    init<S: StringProtocol>(
//        items: [T],
//        searchKeyPaths: [KeyPath<T, S>],
//        @ViewBuilder itemView: @escaping (T) -> V,
//        searchPlaceholder: String = "Search...",
//        emptyStateView: (() -> AnyView)? = nil
//    ) where T: Hashable {
//        self.init(
//            items: items,
//            idProvider: { item in
//                item.hashValue
//            },
//            searchPredicate: { item, searchText in
//                searchKeyPaths.contains { keyPath in
//                    item[keyPath: keyPath].localizedCaseInsensitiveContains(searchText)
//                }
//            },
//            itemView: itemView,
//            searchPlaceholder: searchPlaceholder,
//            emptyStateView: emptyStateView
//        )
//    }
//}
//
//// MARK: - Preview
//
//struct GenericListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Preview with string array
//            NavigationView {
//                GenericListView(
//                    items: ["Apple", "Banana", "Cherry", "Date", "Elderberry"],
//                    searchKeyPath: \.self,
//                    itemView: { item in
//                        HStack {
//                            Text(item)
//                                .font(.body)
//                            Spacer()
//                        }
//                        .padding(.vertical, 4)
//                    },
//                    searchPlaceholder: "Search fruits..."
//                )
//            }
//            .previewDisplayName("String List")
//            
//            // Preview with custom data
//            NavigationView {
//                GenericListView(
//                    items: [
//                        AppointmentItem(id: "1", title: "Meeting with John", date: "2025-01-15"),
//                        AppointmentItem(id: "2", title: "Dental Checkup", date: "2025-01-16"),
//                        AppointmentItem(id: "3", title: "Team Standup", date: "2025-01-17")
//                    ],
//                    searchKeyPaths: [\.title, \.date],
//                    itemView: { item in
//                        VStack(alignment: .leading) {
//                            Text(item.title)
//                                .font(.headline)
//                            Text(item.date)
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        .padding(.vertical, 4)
//                    },
//                    searchPlaceholder: "Search appointments..."
//                )
//            }
//            .previewDisplayName("Custom Data List")
//        }
//    }
//}
//
//// MARK: - Sample Data for Preview
//
//private struct AppointmentItem: Hashable {
//    let id: String
//    let title: String
//    let date: String
//}
