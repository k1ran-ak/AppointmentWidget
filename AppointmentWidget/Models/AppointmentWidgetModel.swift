//
//  AppointmentWidgetModel.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 10/07/25.
//

import Foundation

public protocol AppointmentWidgetModel {
    
    var id: String { get }
    var calendar: String { get }
    var merchantId: String { get }
    var brand: EventBrand { get }
    var type: EventType { get }
    var isExternal: Bool { get }
    var isDeleted: Bool { get }
    var paymentStatus: String? { get }
    var bookingId: String? { get }
    var source: String? { get }
    var parendId: String? { get }
    var isAllDay: Bool { get }
    var metaData: EventMeta? { get }
    var createdTime: Double? { get }
    var updatedTime: Double? { get }
    var dayCount: Int? { get }
    var totalDaysCount: Int? { get }
    
    var provider: [String] { get set }
    var service: [String] { get set }
    var consumer: [String] { get set }
    var startDateTime: String? { get set }
    var endDateTime: String? { get set }
    var zuluStartDate: Date? { get set }
    var zuluEndDate: Date? { get set }
    var startTime: Double { get set }
    var endTime: Double? { get set }
    var maxSeats: Int { get set }
    var cost: Double { get set }
    var rRule: String? { get set }
    var label: String? { get set }
    var title: String? { get set }
    var location: EventLocation? { get set }
    var timezone: String? { get set }
    var notes: String? { get set }
    var createdBy: String? { get set }
    var isSlotChecked: Bool { get set }
    var slotParams: SlotParam? { get set }
    var exceptionDates: [Double]? { get set }
    var eventColor: String? { get set }
}
