//
//  ProviderListView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 01/08/25.
//

import SwiftUI

import SwiftUI


struct Provider: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var serviceIds: [String]
}

let testProviders = [
    Provider(name: "Arnold", serviceIds: [
        "Hair Cut",
        "Trim",
        "Hair wash"
    ]), Provider(name: "Chris Bum", serviceIds: [
        "Hair Cut",
        "Trim"
    ]), Provider(name: "Jay Cutler", serviceIds: [
        "Hair wash"
    ]), Provider(name: "Anush Kiran", serviceIds: [
        "Hair Cut",
        "Trim",
        "Hair wash"
    ])
]

struct ProviderSearchView: View {
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var session: EventViewModel
    let showAll: Bool
    
    var body: some View {
        GenericSearchableListView(data: showAll ? testProviders : session.providers, rowContent: { provider in
            Text(provider.name)
                .onTapGesture {
                    session.draft.provider.append(provider.name)
                    session.draft.createdBy = provider.name
                    session.sessionUserId = provider.name
                    let nextView = session.getNextView(current: .providerList())
                    navigator.push(nextView)
                }
        }, filter: { guest, searchText in
            guest.name.lowercased().contains(searchText.lowercased())
        }, searchPlaceholder: "Search provider")
        .navigationTitle("Select Provider")
        .withChevronBack()
    }
}

#Preview {
    ProviderSearchView(showAll: true)
        .environmentObject(Navigator())
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
}

