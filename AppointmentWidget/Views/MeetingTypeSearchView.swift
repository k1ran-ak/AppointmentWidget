//
//  MeetingTypeSearchView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 18/07/25.
//

import SwiftUI

struct MeetingType: Hashable, Identifiable {
    var id = UUID()
    var name: String
}

let testMeetingTypes = [
    MeetingType(name: "Hair Cut"),
    MeetingType(name: "Trim"),
    MeetingType(name: "Hair wash")
]

struct MeetingTypeSearchView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var eventSession: EventViewModel
    
    var body: some View {
        GenericSearchableListView(data: eventSession.meetingTypes, rowContent: { meetingType in
            Text(meetingType.name)
                .onTapGesture {
                    eventSession.draft.service = [meetingType.name]
                    let nextView = eventSession.getNextView(current: .appointmentList)
                    navigator.push(nextView)
                }
        }, filter: { meetingType, searchText in
            meetingType.name.lowercased().contains(searchText.lowercased())
        }, searchPlaceholder: "Search meeting type")
        .navigationTitle("Select meeting type")
        .withChevronBack()
    }
}

#Preview {
        MeetingTypeSearchView()
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
}

