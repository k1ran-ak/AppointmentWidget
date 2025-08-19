//
//  AppointmentCoordinatorView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 15/07/25.
//

import SwiftUI

struct AppointmentCoordinatorView: Coordinator {
    let initialScreen: Screen
    @State var path: [Screen] = []
    typealias ScreenType = Screen
    @StateObject private var navigator: Navigator = Navigator()
    @StateObject private var eventSession: EventViewModel

    init(initialScreen: Screen, model: EventModel, sessionUserId: String) {
        self.initialScreen = initialScreen
        self.path = []
        self._eventSession = StateObject(
            wrappedValue: EventViewModel(model: model, sessionUserId: sessionUserId))
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if eventSession.hasReachedSummary {
                    routeView(for: .summary)
                } else {
                    routeView(for: initialScreen)
                }
            }
            .animation(.none, value: eventSession.hasReachedSummary)
            .navigationDestination(for: Screen.self) { screen in
                routeView(for: screen)
            }
            .sheet(item: $navigator.sheet) { routeView(for: $0) }
        }
        .onReceive(navigator.$path) { newPath in
            // Sync Navigator's path with Coordinator's path
            if newPath != path {
                path = newPath
            }
        }
        .onChange(of: path) { newPath in
            // Sync Coordinator's path with Navigator's path
            if newPath != navigator.path {
                navigator.path = newPath
            }
        }
        .environmentObject(navigator)
        .environmentObject(eventSession)
    }

    func routeView(for screen: ScreenType) -> some View {
        switch screen {
        case .appointmentList:
            MeetingTypeSearchView()
        case .providerList(let showAll): ProviderSearchView(showAll: showAll)
        case .slotList: SlotSelectionView(selectedDate: Date(), size: 15, selectedSlot: nil)
        case .guestList: GuestSearchView(selectedGuests: eventSession.guests)
        case .summary: EditableAppointmentView(session: eventSession)
        case .overview: Text("Overview")
        case .labelList: LabelListView()
        case .addressSelection: LocationSearchView()
        case .videoMeetSelection: VideoMeetingSelectionView()
        }
    }
}

#Preview {
    AppointmentCoordinatorView(initialScreen: .appointmentList, model: mockEventModel, sessionUserId: testProviders[0].name)
}
