//
//  FakeProviderService.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 11/08/25.
//


import XCTest
@testable import AppointmentWidget

// MARK: - Test Double for ProviderService
private struct MockProviderService: ProviderService {
    var containsReturn: Bool = false

    func getProviders(for selectedServiceId: String?) -> [Provider] { [] }
    func getMeetingTypes(for providerId: String) -> [MeetingType] { [] }
    func getAllMeetingTypes() -> [MeetingType] { [] }

    func doesProviderContains(serviceId: String, providerId: String) -> Bool {
        return containsReturn
    }
}

final class DefaultNavigationServiceTests: XCTestCase {

    private func draft(
        serviceId: String? = nil,
        createdBy: String? = nil
    ) -> EventModel {
        var d = mockEventModel
        if let s = serviceId { d.service = [s] }
        d.createdBy = createdBy ?? d.createdBy
        return d
    }

    // MARK: Default flow (hasReachedSummary == false)

    func test_defaultFlow_appointmentList_goesTo_providerList() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService()
        let next = sut.getNextView(
            current: .appointmentList,
            hasReachedSummary: false,
            draft: draft(),
            providerService: provider
        )

        if case .providerList = next {
            // ok
        } else {
            XCTFail("Expected .providerList, got \(next)")
        }
    }

    func test_defaultFlow_providerList_goesTo_slotList() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService()

        let next = sut.getNextView(
            current: .providerList(),
            hasReachedSummary: false,
            draft: draft(),
            providerService: provider
        )
        XCTAssertEqual(next, .slotList)
    }

    func test_defaultFlow_slotList_goesTo_guestList() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService()

        let next = sut.getNextView(
            current: .slotList,
            hasReachedSummary: false,
            draft: draft(),
            providerService: provider
        )
        XCTAssertEqual(next, .guestList)
    }

    func test_defaultFlow_anyOther_goesTo_summary() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService()
        let screens: [Screen] = [.guestList, .summary, .overview, .labelList, .videoMeetSelection, .addressSelection]

        for screen in screens {
            let next = sut.getNextView(
                current: screen,
                hasReachedSummary: false,
                draft: draft(),
                providerService: provider
            )
            XCTAssertEqual(next, .summary, "Expected .summary for \(screen)")
        }
    }

    // MARK: From summary flow (hasReachedSummary == true)

    func test_fromSummary_appointmentList_goesTo_slotList() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService()

        let next = sut.getNextView(
            current: .appointmentList,
            hasReachedSummary: true,
            draft: draft(),
            providerService: provider
        )
        XCTAssertEqual(next, .slotList)
    }

    func test_fromSummary_providerList_whenProviderSupportsService_goesTo_summary() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService(containsReturn: true)

        let next = sut.getNextView(
            current: .providerList(),
            hasReachedSummary: true,
            draft: draft(serviceId: "S1", createdBy: "P1"),
            providerService: provider
        )
        XCTAssertEqual(next, .summary)
    }

    func test_fromSummary_providerList_whenProviderDoesNotSupportService_goesTo_appointmentList() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService(containsReturn: false)

        let next = sut.getNextView(
            current: .providerList(),
            hasReachedSummary: true,
            draft: draft(serviceId: "S1", createdBy: "P1"),
            providerService: provider
        )
        XCTAssertEqual(next, .appointmentList)
    }

    func test_fromSummary_otherScreens_fallthrough_to_summary() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService()
        let screens: [Screen] = [.slotList, .guestList, .overview, .labelList, .videoMeetSelection, .addressSelection]

        for screen in screens {
            let next = sut.getNextView(
                current: screen,
                hasReachedSummary: true,
                draft: draft(),
                providerService: provider
            )
            XCTAssertEqual(next, .summary, "Expected .summary for \(screen) when from-summary flow")
        }
    }

    // MARK: Edge cases for nils in draft

    func test_fromSummary_providerList_whenNilServiceOrCreatedBy_fallbacksTo_appointmentList() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService(containsReturn: false)

        // nil service
        var d1 = mockEventModel
        d1.service = []
        d1.createdBy = "P1"
        let next1 = sut.getNextView(current: .providerList(), hasReachedSummary: true, draft: d1, providerService: provider)
        XCTAssertEqual(next1, .appointmentList)

        // nil createdBy
        var d2 = mockEventModel
        d2.service = ["S1"]
        d2.createdBy = nil
        let next2 = sut.getNextView(current: .providerList(), hasReachedSummary: true, draft: d2, providerService: provider)
        XCTAssertEqual(next2, .appointmentList)
    }
    
    func test_fromSummary_providerList_whenNilServiceOrCreatedBy_fallbacksTo_appointmentList_isFalse() {
        let sut = DefaultNavigationService()
        let provider = MockProviderService(containsReturn: true)

        // nil service
        var d1 = mockEventModel
        d1.service = []
        d1.createdBy = "P1"
        let next1 = sut.getNextView(current: .providerList(), hasReachedSummary: true, draft: d1, providerService: provider)
        XCTAssertNotEqual(next1, .appointmentList)

        // nil createdBy
        var d2 = mockEventModel
        d2.service = ["S1"]
        d2.createdBy = nil
        let next2 = sut.getNextView(current: .providerList(), hasReachedSummary: true, draft: d2, providerService: provider)
        XCTAssertNotEqual(next2, .appointmentList)
    }
}
