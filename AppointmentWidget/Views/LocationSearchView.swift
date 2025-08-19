//
//  LocationSearchView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 06/08/25.
//

import SwiftUI

struct Location: Identifiable, Hashable {
    
    var id = UUID().uuidString
    var street: String
    var city: String
}

var testLocations: [Location] = [
    Location(street: "1st Street", city: "Madurai"),
    Location(street: "2nd Street", city: "Madurai"),
    Location(street: "3rd Street", city: "Madurai")
]

struct LocationSearchView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var session: EventViewModel
    
    var body: some View {
        GenericSearchableListView(data: testLocations, rowContent: { location in
            VStack(alignment: .leading) {
                Text(location.street)
                Text(location.city)
                    .font(.subheadline)
            }
        }, filter: { location, searchText in
            location.street.contains(searchText) || location.city.contains(searchText)
        }, searchPlaceholder: "Search locations")
        .navigationTitle("Add locations")
        .withChevronBack()
        
    }
}

#Preview {
    LocationSearchView()
        .environmentObject(Navigator())
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
}
