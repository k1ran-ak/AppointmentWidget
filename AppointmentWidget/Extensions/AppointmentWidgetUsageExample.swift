////
////  AppointmentWidgetUsageExample.swift
////  AppointmentWidget
////
////  Created by Anush Kiran on 10/07/25.
////
//
//import Foundation
//import SwiftUI
//
///// Example usage of the new view models
//struct AppointmentWidgetUsageExample {
//    
//    /// Example: Creating an overview view model for existing appointment
//    static func createOverviewViewModel(from eventModel: EventModel) -> AppointmentOverviewViewModel {
//        let appointmentInterface = eventModel.toAppointmentWidgetModel()
//        return AppointmentOverviewViewModel(appointment: appointmentInterface)
//    }
//    
//    /// Example: Creating a summary view model for existing appointment (editing)
//    static func createSummaryViewModelForExisting(from eventModel: EventModel) -> AppointmentSummaryViewModel {
//        let appointmentInterface = eventModel.toAppointmentWidgetModel()
//        return AppointmentSummaryViewModel(appointment: appointmentInterface)
//    }
//    
//    /// Example: Creating a summary view model for new appointment
//    static func createSummaryViewModelForNew(merchantId: String, calendar: String) -> AppointmentSummaryViewModel {
//        return AppointmentSummaryViewModel(merchantId: merchantId, calendar: calendar)
//    }
//    
//    /// Example: API integration in summary view model
//    static func exampleAPIIntegration() async {
//        // Create a new appointment
//        let summaryVM = AppointmentSummaryViewModel(
//            merchantId: "merchant123",
//            calendar: "calendar456"
//        )
//        
//        // User fills in the form...
//        // summaryVM.draft.title = "New Appointment"
//        // summaryVM.draft.startDateTime = "2025-01-15T10:00:00Z"
//        // summaryVM.draft.endDateTime = "2025-01-15T11:00:00Z"
//        
//        do {
//            // Save the appointment
//            let savedAppointment = try await summaryVM.save()
//            print("Appointment saved: \(savedAppointment.id)")
//            
//            // Now create an overview view model with the saved appointment
//            let overviewVM = AppointmentOverviewViewModel(appointment: savedAppointment)
//            
//        } catch {
//            print("Failed to save appointment: \(error)")
//        }
//    }
//}
//
///// Example SwiftUI views using the view models
//struct AppointmentOverviewView: View {
//    @StateObject private var viewModel: AppointmentOverviewViewModel
//    
//    init(appointment: AppointmentWidgetModel) {
//        self._viewModel = StateObject(wrappedValue: AppointmentOverviewViewModel(appointment: appointment))
//    }
//    
//    var body: some View {
//        List(viewModel.overviewRows) { row in
//            HStack {
//                Text(row.label)
//                    .font(.headline)
//                Spacer()
//                Text(row.value)
//                    .font(.body)
//                    .foregroundColor(.secondary)
//            }
//        }
//        .navigationTitle("Appointment Overview")
//    }
//}
//
//struct AppointmentSummaryView: View {
//    @StateObject private var viewModel: AppointmentSummaryViewModel
//    @State private var showingSaveAlert = false
//    
//    init(appointment: AppointmentWidgetModel) {
//        self._viewModel = StateObject(wrappedValue: AppointmentSummaryViewModel(appointment: appointment))
//    }
//    
//    init(merchantId: String, calendar: String) {
//        self._viewModel = StateObject(wrappedValue: AppointmentSummaryViewModel(merchantId: merchantId, calendar: calendar))
//    }
//    
//    var body: some View {
//        Form {
//            ForEach(viewModel.descriptors) { descriptor in
//                Section(header: Text(descriptor.label)) {
//                    switch descriptor.inputType {
//                    case .text:
//                        TextField(descriptor.label, text: Binding(
//                            get: { descriptor.get(viewModel.draft) },
//                            set: { descriptor.set(&viewModel.draft, $0) }
//                        ))
//                    case .multiline:
//                        TextEditor(text: Binding(
//                            get: { descriptor.get(viewModel.draft) },
//                            set: { descriptor.set(&viewModel.draft, $0) }
//                        ))
//                        .frame(minHeight: 100)
//                    case .date:
//                        DatePicker(descriptor.label, selection: Binding(
//                            get: { viewModel.draft.zuluStartDate ?? Date() },
//                            set: { viewModel.draft.zuluStartDate = $0 }
//                        ), displayedComponents: [.date, .hourAndMinute])
//                    }
//                }
//            }
//        }
//        .navigationTitle(viewModel.isNewAppointment ? "New Appointment" : "Edit Appointment")
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Save") {
//                    Task {
//                        do {
//                            _ = try await viewModel.save()
//                            showingSaveAlert = true
//                        } catch {
//                            print("Save failed: \(error)")
//                        }
//                    }
//                }
//                .disabled(!viewModel.hasChanges)
//            }
//        }
//        .alert("Appointment Saved", isPresented: $showingSaveAlert) {
//            Button("OK") { }
//        }
//    }
//} 
