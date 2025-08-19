//
//  SearchBar.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 21/07/25.
//


import SwiftUI
import Combine

/// A reusable SwiftUI “search bar” you can stick above any list
struct SearchBar: View {
  @Binding var text: String
  let placeholder: String
  let debounceTime: TimeInterval

  @State private var debouncedText: String = ""
  @State private var cancellable: AnyCancellable?

  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
      TextField(placeholder, text: $text)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .onChange(of: text) { new in
          // debounce typing
          cancellable?.cancel()
          cancellable = Just(new)
            .delay(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .sink { debouncedText = $0 }
        }
    }
    .padding(8)
    .background(Color(.secondarySystemBackground))
    .cornerRadius(8)
    .padding(.horizontal)
  }

  /// Expose your debounced value
  func filtered<T: Identifiable>(
    from data: [T],
    matching filter: (T, String) -> Bool
  ) -> [T] {
    guard !debouncedText.isEmpty else { return data }
    return data.filter { filter($0, debouncedText) }
  }
}


#Preview {
    SearchBar(text: .constant(""), placeholder: "Search", debounceTime: 0.3)
}
