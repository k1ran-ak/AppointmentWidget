////
////  AppointmentSummaryViewModel.swift
////  AppointmentWidget
////
////  Created by Anush Kiran on 10/07/25.
////
//
//import Foundation
//import SwiftUI
//import Combine
//
///// Editable view model for appointment summary
///// Can handle both existing appointments (with values) and new appointments (with optional values)
//final class AppointmentSummaryViewModel: ObservableObject {
//    @Published private(set) var original: AppointmentWidgetModel?
//    @Published var draft: AppointmentWidgetModel
//    
//    /// Tracks which fields have been edited
//    @Published private(set) var changedFields = Set<AppointmentWidgetField>()
//    
//    private var cancellable: AnyCancellable?
//    
//    /// Editable field descriptors for the appointment
//    let descriptors: [EditableFieldDescriptor<AppointmentWidgetModel>] = [
//        .init(
//            id: .title,
//            label: "Title",
//            inputType: .text,
//            get: { $0.title ?? "" },
//            set: { $0.title = $1.isEmpty ? nil : $1 }
//        ),
//        .init(
//            id: .startDateTime,
//            label: "Start Date & Time",
//            inputType: .date,
//            get: { model in
//                guard let date = model.zuluStartDate else { return "" }
//                return ISO8601DateFormatter().string(from: date)
//            },
//            set: { model, new in
//                if let date = ISO8601DateFormatter().date(from: new) {
//                    model.zuluStartDate = date
//                    model.startDateTime = new
//                    model.startTime = date.timeIntervalSince1970 * 1000
//                }
//            }
//        ),
//        .init(
//            id: .endDateTime,
//            label: "End Date & Time",
//            inputType: .date,
//            get: { model in
//                guard let date = model.zuluEndDate else { return "" }
//                return ISO8601DateFormatter().string(from: date)
//            },
//            set: { model, new in
//                if let date = ISO8601DateFormatter().date(from: new) {
//                    model.zuluEndDate = date
//                    model.endDateTime = new
//                    model.endTime = date.timeIntervalSince1970 * 1000
//                }
//            }
//        ),
//        .init(
//            id: .label,
//            label: "Label",
//            inputType: .text,
//            get: { $0.label ?? "" },
//            set: { $0.label = $1.isEmpty ? nil : $1 }
//        ),
//        .init(
//            id: .notes,
//            label: "Notes",
//            inputType: .multiline,
//            get: { $0.notes ?? "" },
//            set: { $0.notes = $1.isEmpty ? nil : $1 }
//        ),
//        .init(
//            id: .cost,
//            label: "Cost",
//            inputType: .text,
//            get: { String(format: "%.2f", $0.cost) },
//            set: { model, new in
//                if let cost = Double(new) {
//                    model.cost = cost
//                }
//            }
//        ),
//        .init(
//            id: .seats,
//            label: "Max Seats",
//            inputType: .text,
//            get: { "\($0.maxSeats)" },
//            set: { model, new in
//                if let seats = Int(new) {
//                    model.maxSeats = seats
//                }
//            }
//        ),
//        .init(
//            id: .eventColor,
//            label: "Event Color",
//            inputType: .text,
//            get: { $0.eventColor ?? "" },
//            set: { $0.eventColor = $1.isEmpty ? nil : $1 }
//        )
//    ]
//    
//    /// Initialize with existing appointment data
//    init(appointment: AppointmentWidgetModel) {
//        self.original = appointment
//        self.draft = appointment
//        
//        setupChangeTracking()
//    }
//    
//    /// Initialize for creating a new appointment (with default values)
//    init(merchantId: String, calendar: String, brand: EventBrand = .SetMore) {
//        // Create a default appointment interface with minimal required fields
//        let defaultAppointment = DefaultAppointmentWidgetModel(
//            id: UUID().uuidString,
//            calendar: calendar,
//            merchantId: merchantId,
//            brand: brand,
//            type: .appointment,
//            isExternal: false,
//            isDeleted: false,
//            paymentStatus: nil,
//            bookingId: nil,
//            source: nil,
//            parendId: nil,
//            isAllDay: false,
//            metaData: nil,
//            createdTime: nil,
//            updatedTime: nil,
//            dayCount: nil,
//            totalDaysCount: nil,
//            provider: [],
//            service: [],
//            consumer: [],
//            startDateTime: nil,
//            endDateTime: nil,
//            zuluStartDate: nil,
//            zuluEndDate: nil,
//            startTime: Date().timeIntervalSince1970 * 1000,
//            endTime: nil,
//            maxSeats: 1,
//            cost: 0.0,
//            rRule: nil,
//            label: nil,
//            title: nil,
//            location: nil,
//            timezone: TimeZone.current.identifier,
//            notes: nil,
//            createdBy: nil,
//            isSlotChecked: false,
//            slotParams: nil,
//            exceptionDates: nil,
//            eventColor: nil
//        )
//        
//        self.original = nil // No original data for new appointments
//        self.draft = defaultAppointment
//        
//        setupChangeTracking()
//    }
//    
//    private func setupChangeTracking() {
//        // Watch the entire `draft` and diff it against `original`
//        cancellable = $draft
//            .sink { [weak self] newModel in
//                guard let self = self else { return }
//                
//                // For new appointments, track changes from initial state
//                let baseModel = self.original ?? self.draft
//                
//                self.changedFields = Set(
//                    self.descriptors.compactMap { desc in
//                        let oldVal = desc.get(baseModel)
//                        let newVal = desc.get(newModel)
//                        return oldVal != newVal ? desc.id : nil
//                    }
//                )
//            }
//    }
//    
//    /// Save the appointment (create or update)
//    func save() async throws -> AppointmentWidgetModel {
//        // Convert draft to EventModel for API call
//        let eventModel = draft.toEventModel()
//        
//        // Here you would typically:
//        // 1. Call your API (create or update)
//        // 2. Convert the response back to AppointmentWidgetModel
//        
//        // For now, we'll simulate the API call and return the draft
//        // In real implementation, you would do something like:
//        // let responseEventModel = try await apiService.createOrUpdateAppointment(eventModel)
//        // let updated = responseEventModel.toAppointmentWidgetModel()
//        
//        let updated = draft
//        
//        await MainActor.run {
//            if original == nil {
//                // This was a new appointment, now it has an original
//                original = updated
//            } else {
//                // Update the original reference
//                original = updated
//            }
//            draft = updated
//        }
//        
//        return updated
//    }
//    
//    /// Reset to original values
//    func reset() {
//        if let original = original {
//            draft = original
//        }
//    }
//    
//    /// Convenience properties for the view
//    var hasChanges: Bool { !changedFields.isEmpty }
//    var isNewAppointment: Bool { original == nil }
//    
//    func onlyChanged(_ field: AppointmentWidgetField) -> Bool {
//        changedFields == [field]
//    }
//}
//
///// Default implementation of AppointmentWidgetModel for new appointments
//private struct DefaultAppointmentWidgetModel: AppointmentWidgetModel {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: DefaultAppointmentWidgetModel, rhs: DefaultAppointmentWidgetModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: String
//    var calendar: String
//    var merchantId: String
//    var brand: EventBrand
//    var type: EventType
//    var isExternal: Bool
//    var isDeleted: Bool
//    var paymentStatus: String?
//    var bookingId: String?
//    var source: String?
//    var parendId: String?
//    var isAllDay: Bool
//    var metaData: EventMeta?
//    var createdTime: Double?
//    var updatedTime: Double?
//    var dayCount: Int?
//    var totalDaysCount: Int?
//    var provider: [String]
//    var service: [String]
//    var consumer: [String]
//    var startDateTime: String?
//    var endDateTime: String?
//    var zuluStartDate: Date?
//    var zuluEndDate: Date?
//    var startTime: Double
//    var endTime: Double?
//    var maxSeats: Int
//    var cost: Double
//    var rRule: String?
//    var label: String?
//    var title: String?
//    var location: EventLocation?
//    var timezone: String?
//    var notes: String?
//    var createdBy: String?
//    var isSlotChecked: Bool
//    var slotParams: SlotParam?
//    var exceptionDates: [Double]?
//    var eventColor: String?
//} 
