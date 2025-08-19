//
//  Guest.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 21/07/25.
//

import SwiftUI


struct Guest: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var email: String?
    var isProvider: Bool = false
}

let testProvidersAsGuest = testProviders.map({ Guest(name: $0.name, isProvider: true) })

let testGuests = [
    Guest(name: "Virat", email: nil),
    Guest(name: "Sachin", email: "sachin@anywhere.co"),
    Guest(name: "Rahul", email: "rahul@answerconnect.com"),
    Guest(name: "MS Dhoni", email: "msd@anywhere.co")
]

struct GuestSearchView: View {
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var session: EventViewModel
    @State var selectedGuests: Set<String>
    var testGuestData: [Guest] = testGuests + testProvidersAsGuest
    
    init(selectedGuests: [String]) {
        self.selectedGuests = Set(selectedGuests)
    }
    
    var body: some View {
        GenericSearchableListView(data: testGuestData.filter({ $0.name != session.sessionUserId }), rowContent: { guest in
            GuestRowView(guest: guest.name,
                         isSelected: selectedGuests.contains(guest.name),
                         isProvider: guest.isProvider)
                .contentShape(Rectangle())
                .onTapGesture {
                    let isSelected: Bool = selectedGuests.contains(guest.name)
                    if isSelected {
                        selectedGuests.remove(guest.name)
                    } else {
                        selectedGuests.insert(guest.name)
                    }
                }
        }, filter: { guest, searchText in
            guest.name.lowercased().contains(searchText.lowercased())
        }, searchPlaceholder: "Search guest")
        .navigationTitle("Select Guest")
        .withChevronBack()
        .withNextButton(isDisabled: selectedGuests.count == 0) {
            let consumers = selectedGuests.filter({ testGuests.map(\.name).contains($0)})
            let providers = selectedGuests.filter({ testProviders.map(\.name).contains($0)})
            session.draft.consumer = Array(consumers)
            session.draft.provider = Array(providers)
            let nextView = session.getNextView(current: .guestList)
            navigator.push(nextView)
        }
    }
}

struct GuestRowView: View {
    var guest: String
    var isSelected: Bool = false
    var isProvider: Bool = false
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var session: EventViewModel
    
    var body: some View {
        HStack {
            Text(guest)
            if isProvider {
                Image(systemName: "person")
            }
            Spacer()
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
        }
    }
}

#Preview {
    GuestSearchView(selectedGuests: [testGuests[0].name])
        .environmentObject(Navigator())
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
}
