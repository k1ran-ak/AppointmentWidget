////
////  AppointmentOverviewViewModel.swift
////  AppointmentWidget
////
////  Created by Anush Kiran on 10/07/25.
////
//
//import Foundation
//import SwiftUI
//
///// Read-only view model for displaying appointment overview
///// Always has values since it's constructed from existing appointment data
//final class AppointmentOverviewViewModel: ObservableObject {
//    @Published private(set) var appointment: AppointmentWidgetModel
//    
//    private let overviewDescriptors: [FieldDescriptor<AppointmentWidgetModel>] = [
//        .init(.title, label: "Title") { $0.title ?? "No Title" },
//        
//        .init(.startDateTime, label: "Starts") {
//            guard let date = $0.zuluStartDate else { return "Not set" }
//            return DateFormatter
//                .localizedString(from: date,
//                               dateStyle: .short,
//                               timeStyle: .short)
//        },
//        
//        .init(.endDateTime, label: "Ends") {
//            guard let date = $0.zuluEndDate else { return "Not set" }
//            return DateFormatter
//                .localizedString(from: date,
//                               dateStyle: .short,
//                               timeStyle: .short)
//        },
//        
//        .init(.label, label: "Label") { $0.label ?? "—" },
//        
//        .init(.notes, label: "Notes") { $0.notes ?? "—" },
//        
//        .init(.cost, label: "Cost") {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .currency
//            return formatter.string(from: NSNumber(value: $0.cost)) ?? "$0.00"
//        },
//        
//            .init(.seats, label: "Max Seats") { "\($0.maxSeats)" },
//        
//        .init(.location, label: "Location") {
//            if let location = $0.location {
//                return location.customLocation ?? "Location set"
//            }
//            return "No location"
//        },
//        
////        .init(.timezone, label: "Timezone") { $0.timezone ?? "Default" },
////        
////        .init(.bookingId, label: "Booking ID") { $0.bookingId },
////        
////        .init(.paymentStatus, label: "Payment Status") { $0.paymentStatus },
////        
////        .init(.type, label: "Type") { $0.type.rawValue },
////        
////        .init(.brand, label: "Brand") { $0.brand.rawValue }
//    ]
//    
//    var overviewRows: [OverviewRow] {
//        overviewDescriptors.map { desc in
//            OverviewRow(
//                id: desc.id,
//                label: desc.label,
//                value: desc.makeText(appointment)
//            )
//        }
//    }
//    
//    init(appointment: AppointmentWidgetModel) {
//        self.appointment = appointment
//    }
//    
//    /// Update the appointment data (e.g., after API refresh)
//    func updateAppointment(_ newAppointment: AppointmentWidgetModel) {
//        withAnimation {
//            self.appointment = newAppointment
//        }
//    }
//}
//
//struct OverviewRow: Identifiable {
//    let id: AppointmentWidgetField
//    let label: String
//    let value: String
//} 
