//
//  CoordinatableScreen.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 15/07/25.
//

import SwiftUI

// MARK: - Coordinator Protocol

public protocol CoordinatableScreen: Hashable, Identifiable {}

public protocol Coordinator: View {
    associatedtype ScreenType: CoordinatableScreen

    var path: [ScreenType] { get set }
    associatedtype CoordinatorBody: View
    @ViewBuilder func routeView(for screen: ScreenType) -> CoordinatorBody

    mutating func push(_ screen: ScreenType)
    mutating func pop()
    mutating func popToRoot()
}

extension Coordinator {
    public mutating func push(_ screen: ScreenType) {
        path.append(screen)
    }

    public mutating func pop() {
        _ = path.popLast()
    }

    public mutating func popToRoot() {
        path.removeAll()
    }
}

public enum Screen: CoordinatableScreen {
    case appointmentList
    case providerList(showAll: Bool = false)
    case slotList
    case guestList
    case summary
    case overview
    case labelList
    case videoMeetSelection
    case addressSelection
    
    public var id: String { return self.hashValue.formatted() }
}

