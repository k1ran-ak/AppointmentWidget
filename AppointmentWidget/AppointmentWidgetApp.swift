//
//  AppointmentWidgetApp.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 07/07/25.
//

import SwiftUI

@main
struct AppointmentWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AppointmentCoordinatorView(initialScreen: .appointmentList, model: mockEventModel, sessionUserId: testProviders[0].name)
            }
        }
    }
}

#Preview {
    AppointmentCoordinatorView(initialScreen: .appointmentList, model: mockEventModel, sessionUserId: testProviders[0].name)
}
