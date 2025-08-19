//
//  EventViewModel.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 22/07/25.
//

import SwiftUI

// MARK: - Protocols for Dependency Injection
protocol ProviderService {
    
    func getProviders(for selectedServiceId: String?) -> [Provider]
    func getMeetingTypes(for providerId: String) -> [MeetingType]
    func doesProviderContains(serviceId: String, providerId: String) -> Bool
}

protocol NavigationService {
    func getNextView(current: Screen, hasReachedSummary: Bool, draft: EventModel, providerService: ProviderService) -> Screen
}

// MARK: - Default Implementations
final class DefaultProviderService: ProviderService {
    
    func getProviders(for selectedServiceId: String?) -> [Provider] {
        testProviders.filter { provider in
            provider.serviceIds.contains { serviceId in
                guard let selectedServiceId else { return true }
                return selectedServiceId == serviceId
            }
        }
    }
    
    func getMeetingTypes(for providerId: String) -> [MeetingType] {
        guard let provider = testProviders.first(where: { $0.name == providerId }) else {
            return getAllMeetingTypes()
        }
        return getAllMeetingTypes().filter { provider.serviceIds.contains($0.name) }
    }
    
    private func getAllMeetingTypes() -> [MeetingType] {
        return testMeetingTypes
    }
    
    func doesProviderContains(serviceId: String, providerId: String) -> Bool {
        let provider = testProviders.first(where: { $0.name == providerId })
        return provider?.serviceIds.contains(serviceId) ?? false
    }
}

final class DefaultNavigationService: NavigationService {
    
    func getNextView(current: Screen, hasReachedSummary: Bool, draft: EventModel, providerService: ProviderService) -> Screen {
        guard !hasReachedSummary else {
            return getNextViewFromSummary(current: current, draft: draft, providerService: providerService)
        }
        
        switch current {
        case .appointmentList:
            return .providerList()
        case .providerList:
            return .slotList
        case .slotList:
            return .guestList
        default:
            return .summary
        }
    }
    
    private func getNextViewFromSummary(current: Screen, draft: EventModel, providerService: ProviderService) -> Screen {
        switch current {
        case .appointmentList:
            return .slotList
        case .providerList:
            if providerService.doesProviderContains(serviceId: draft.service.first ?? "", providerId: draft.createdBy ?? "") {
                return .summary
            } else {
                return .appointmentList
            }
        default:
            return .summary
        }
    }
}

// MARK: - EventViewModel
final class EventViewModel: ObservableObject {
    
    @Published private(set) var original: EventModel
    @Published var draft: EventModel
    @Published var hasReachedSummary: Bool = false
    var sessionUserId: String // calendarId
    var videoIntegration: VideoIntegration?
    private let providerService: ProviderService
    private var navigationService: NavigationService
    
    var meetingTypes: [MeetingType] {
        providerService.getMeetingTypes(for: sessionUserId)
    }
    
    var providers: [Provider] {
        providerService.getProviders(for: draft.service.first)
    }
    
    var guests: [String] {
        (draft.provider + draft.consumer).filter({ $0 != sessionUserId })
    }

    init(model: EventModel, sessionUserId: String, providerService: ProviderService = DefaultProviderService(), navigationService: NavigationService = DefaultNavigationService()) {
        self.original = model
        self.draft  = model
        self.sessionUserId = sessionUserId
        self.providerService = providerService
        self.navigationService = navigationService
    }

    func apply(_ new: EventModel) {
        draft = new
    }

    func reset() {
        draft = original
    }

    func commit() {
        original = draft
    }
    
    func resetNavigationState() {
        hasReachedSummary = true
    }
    
    /// Default flow
    func getNextView(current: Screen) -> Screen {
        navigationService.getNextView(current: current, hasReachedSummary: hasReachedSummary, draft: draft, providerService: providerService)
    }
    
    func setVideoIntegration() {
        guard let videoIntegration = videoIntegration else { return }
        if let location = draft.location {
            self.draft.location = location.setVideoType([VideoMeeting(type: videoIntegration.name)])
        } else {
            self.draft.location = EventLocation().setVideoType([VideoMeeting(type: videoIntegration.name)])
        }
    }
    
    func resetVideoIntegration() {
        if let location = draft.location {
            self.draft.location = location.setVideoType(nil)
        } 
    }
}
