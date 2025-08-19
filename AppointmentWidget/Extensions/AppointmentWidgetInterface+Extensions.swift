//
//  AppointmentWidgetModel+Extensions.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 10/07/25.
//

import Foundation

// MARK: - EventModel Conversion
extension EventModel {
    /// Convert EventModel to AppointmentWidgetModel
    func toAppointmentWidgetModel() -> AppointmentWidgetModel {
        return EventModelAppointmentWidgetModel(from: self)
    }
}

// MARK: - AppointmentWidgetModel Conversion
extension AppointmentWidgetModel {
    /// Convert AppointmentWidgetModel to EventModel for API calls
    func toEventModel() -> EventModel {
        return EventModel(
            id: self.id,
            calendar: self.calendar,
            merchant: self.merchantId,
            brand: self.brand,
            type: self.type,
            provider: self.provider,
            service: self.service,
            consumer: self.consumer,
            resource: [], // Not in interface, default to empty
            startDateTime: self.startDateTime,
            endDateTime: self.endDateTime,
            zuluStartDate: self.zuluStartDate,
            zuluEndDate: self.zuluEndDate,
            startTime: self.startTime,
            endTime: self.endTime,
            maxSeats: self.maxSeats,
            cost: self.cost,
            isExternal: self.isExternal,
            isDeleted: self.isDeleted,
            rRule: self.rRule,
            paymentStatus: self.paymentStatus,
            label: self.label,
            bookingId: self.bookingId,
            source: self.source,
            parentId: self.parendId,
            title: self.title,
            isAllDay: self.isAllDay,
            location: self.location,
            metaData: self.metaData,
            timezone: self.timezone,
            notes: self.notes,
            createdBy: self.createdBy,
            createdTime: self.createdTime,
            updatedTime: self.updatedTime,
            dayCount: self.dayCount,
            totalDaysCount: self.totalDaysCount,
            isSlotCheck: self.isSlotChecked,
            slotParams: self.slotParams,
            videoIntegration: nil, // Not in interface, default to nil
            exceptionDates: self.exceptionDates,
            eventColor: self.eventColor
        )
    }
}

// MARK: - Concrete Implementation
private struct EventModelAppointmentWidgetModel: AppointmentWidgetModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EventModelAppointmentWidgetModel, rhs: EventModelAppointmentWidgetModel) -> Bool {
        return lhs.id == rhs.id
    }
    let id: String
    let calendar: String
    let merchantId: String
    let brand: EventBrand
    let type: EventType
    let isExternal: Bool
    let isDeleted: Bool
    let paymentStatus: String?
    let bookingId: String?
    let source: String?
    let parendId: String?
    let isAllDay: Bool
    let metaData: EventMeta?
    let createdTime: Double?
    let updatedTime: Double?
    let dayCount: Int?
    let totalDaysCount: Int?
    var provider: [String]
    var service: [String]
    var consumer: [String]
    var startDateTime: String?
    var endDateTime: String?
    var zuluStartDate: Date?
    var zuluEndDate: Date?
    var startTime: Double
    var endTime: Double?
    var maxSeats: Int
    var cost: Double
    var rRule: String?
    var label: String?
    var title: String?
    var location: EventLocation?
    var timezone: String?
    var notes: String?
    var createdBy: String?
    var isSlotChecked: Bool
    var slotParams: SlotParam?
    var exceptionDates: [Double]?
    var eventColor: String?
    
    init(from eventModel: EventModel) {
        self.id = eventModel.id
        self.calendar = eventModel.calendar
        self.merchantId = eventModel.merchant
        self.brand = eventModel.brand
        self.type = eventModel.type ?? .event
        self.isExternal = eventModel.isExternal
        self.isDeleted = eventModel.isDeleted
        self.paymentStatus = eventModel.paymentStatus
        self.bookingId = eventModel.bookingId
        self.source = eventModel.source
        self.parendId = eventModel.parentId
        self.isAllDay = eventModel.isAllDay ?? false
        self.metaData = eventModel.metaData
        self.createdTime = eventModel.createdTime
        self.updatedTime = eventModel.updatedTime
        self.dayCount = eventModel.dayCount
        self.totalDaysCount = eventModel.totalDaysCount
        self.provider = eventModel.provider
        self.service = eventModel.service
        self.consumer = eventModel.consumer
        self.startDateTime = eventModel.startDateTime
        self.endDateTime = eventModel.endDateTime
        self.zuluStartDate = eventModel.zuluStartDate
        self.zuluEndDate = eventModel.zuluEndDate
        self.startTime = eventModel.startTime
        self.endTime = eventModel.endTime
        self.maxSeats = eventModel.maxSeats
        self.cost = eventModel.cost
        self.rRule = eventModel.rRule
        self.label = eventModel.label
        self.title = eventModel.title
        self.location = eventModel.location
        self.timezone = eventModel.timezone
        self.notes = eventModel.notes
        self.createdBy = eventModel.createdBy
        self.isSlotChecked = eventModel.isSlotCheck ?? false
        self.slotParams = eventModel.slotParams
        self.exceptionDates = eventModel.exceptionDates
        self.eventColor = eventModel.eventColor
    }
} 
