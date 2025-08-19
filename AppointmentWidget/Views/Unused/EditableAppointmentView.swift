////
////  EditableAppointmentView.swift
////  AppointmentWidget
////
////  Created by Anush Kiran on 10/07/25.
////
//
//import SwiftUI
//
//struct EditableAppointmentView: View {
//   
//    @State private var showingSaveAlert = false
//    @State private var showingDiscardAlert = false
//    @Environment(\.dismiss) private var dismiss
//
//    @EnvironmentObject var session: EventSession
//
//    @State private var draft: AppointmentWidgetModel
//    @State private var isSaving = false
//
//    init(session: EventSession) {
//        _draft = State(initialValue: session.current)
//    }
//    
//    // MARK: - Body
//    
//    var body: some View {
//        Form {
//            // Title Section
//            Section(header: Text("Appointment Details")) {
//                HStack {
//                    Circle()
//                        .fill(Color.orange)
//                        .frame(width: 12, height: 12)
//                    VStack(alignment: .leading) {
//                        Text("Title")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        TextField("Enter appointment title", text: $title)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                }
//            }
//            
//            // Date & Time Section
//            Section(header: Text("Date & Time")) {
//                // Start Date & Time
//                HStack {
//                    Image(systemName: "clock")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("Start Date & Time")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        DatePicker("", selection: Binding(
//                            get: { viewModel.draft.zuluStartDate ?? Date() },
//                            set: { 
//                                viewModel.draft.zuluStartDate = $0
//                                viewModel.draft.startDateTime = ISO8601DateFormatter().string(from: $0)
//                                viewModel.draft.startTime = $0.timeIntervalSince1970 * 1000
//                            }
//                        ), displayedComponents: [.date, .hourAndMinute])
//                        .labelsHidden()
//                    }
//                }
//                
//                // End Date & Time
//                HStack {
//                    Image(systemName: "clock.badge")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("End Date & Time")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        DatePicker("", selection: Binding(
//                            get: { viewModel.draft.zuluEndDate ?? Date().addingTimeInterval(3600) },
//                            set: { 
//                                viewModel.draft.zuluEndDate = $0
//                                viewModel.draft.endDateTime = ISO8601DateFormatter().string(from: $0)
//                                viewModel.draft.endTime = $0.timeIntervalSince1970 * 1000
//                            }
//                        ), displayedComponents: [.date, .hourAndMinute])
//                        .labelsHidden()
//                    }
//                }
//            }
//            
//             Cost & Seats Section
//            Section(header: Text("Pricing & Capacity")) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Cost")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        TextField(0.0, text: $cost)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.decimalPad)
//                    }
//                    Spacer()
//                    VStack(alignment: .leading) {
//                        Text("Max Seats")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        TextField("0", text: $seats)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.numberPad)
//                    }
//                }
//            }
//            
//            // Label Section
//            Section(header: Text("Label")) {
//                HStack {
//                    Image(systemName: "tag")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("Label")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        TextField("Add label", text: $label)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                }
//            }
//            
//            // Notes Section
//            Section(header: Text("Notes")) {
//                HStack(alignment: .center) {
//                    Image(systemName: "note.text")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        TextEditor(text: Binding(
//                            get: { viewModel.draft.notes ?? "Add notes" },
//                            set: { viewModel.draft.notes = $0.isEmpty ? nil : $0 }
//                        ))
////                        .frame(minHeight: 80)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                }
//            }
//            
//            // Event Color Section
//            Section(header: Text("Appearance")) {
//                HStack {
//                    Image(systemName: "paintbrush")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("Event Color")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        TextField("Color code (e.g., #FF5733)", text: Binding(
//                            get: { viewModel.draft.eventColor ?? "" },
//                            set: { viewModel.draft.eventColor = $0.isEmpty ? nil : $0 }
//                        ))
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                }
//            }
//            
//            // Read-only Information (for existing appointments)
//            if !viewModel.isNewAppointment {
//                Section(header: Text("Appointment Information")) {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Booking ID")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Text(viewModel.draft.bookingId ?? "—")
//                                .font(.body)
//                        }
//                        Spacer()
//                    }
//                    
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Payment Status")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Text(viewModel.draft.paymentStatus ?? "—")
//                                .font(.body)
//                        }
//                        Spacer()
//                    }
//                    
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Type")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Text(viewModel.draft.type.rawValue)
//                                .font(.body)
//                        }
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .navigationTitle(viewModel.isNewAppointment ? "New Appointment" : "Edit Appointment")
//        .navigationBarItems(
//            leading: Button("Cancel") {
//                if viewModel.hasChanges {
//                    showingDiscardAlert = true
//                } else {
//                    dismiss()
//                }
//            },
//            trailing: Button("Save") {
//                Task {
//                    do {
//                        _ = try await viewModel.save()
//                        showingSaveAlert = true
//                    } catch {
//                        print("Save failed: \(error)")
//                    }
//                }
//            }
//            .disabled(!viewModel.hasChanges)
//        )
//        .alert("Appointment Saved", isPresented: $showingSaveAlert) {
//            Button("OK") {
//                dismiss()
//            }
//        } message: {
//            Text("Your appointment has been saved successfully.")
//        }
//        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
//            Button("Discard", role: .destructive) {
//                viewModel.reset()
//                dismiss()
//            }
//            Button("Keep Editing", role: .cancel) { }
//        } message: {
//            Text("Are you sure you want to discard your changes?")
//        }
//    }
//}
//
//// MARK: - Preview
//
//struct EditableAppointmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Preview for new appointment
//            EditableAppointmentView()
//                .previewDisplayName("New Appointment")
//            
//            // Preview for existing appointment
//            EditableAppointmentView()
//                .previewDisplayName("Edit Existing Appointment")
//        }
//        .environmentObject(AppointmentSummaryViewModel(merchantId: "some", calendar: "123"))
//    }
//    
//    static func createSampleAppointment() -> AppointmentWidgetModel {
//        return SampleAppointmentWidgetModel(
//            id: "sample-123",
//            calendar: "sample-calendar",
//            merchantId: "sample-merchant",
//            brand: .SetMore,
//            type: .appointment,
//            isExternal: false,
//            isDeleted: false,
//            paymentStatus: "PENDING",
//            bookingId: "BK-123456",
//            source: "WIDGET",
//            parendId: nil,
//            isAllDay: false,
//            metaData: nil,
//            createdTime: Date().timeIntervalSince1970 * 1000,
//            updatedTime: Date().timeIntervalSince1970 * 1000,
//            dayCount: nil,
//            totalDaysCount: nil,
//            provider: ["provider1"],
//            service: ["service1"],
//            consumer: ["consumer1"],
//            startDateTime: "2025-01-15T10:00:00Z",
//            endDateTime: "2025-01-15T11:00:00Z",
//            zuluStartDate: Date().addingTimeInterval(3600),
//            zuluEndDate: Date().addingTimeInterval(7200),
//            startTime: Date().addingTimeInterval(3600).timeIntervalSince1970 * 1000,
//            endTime: Date().addingTimeInterval(7200).timeIntervalSince1970 * 1000,
//            maxSeats: 2,
//            cost: 150.0,
//            rRule: nil,
//            label: "Paid",
//            title: "Sample Appointment",
//            location: nil,
//            timezone: "UTC",
//            notes: "This is a sample appointment for preview purposes.",
//            createdBy: "user123",
//            isSlotChecked: false,
//            slotParams: nil,
//            exceptionDates: nil,
//            eventColor: "#FF5733"
//        )
//    }
//}
//
//// MARK: - Sample Implementation for Preview
//
//private struct SampleAppointmentWidgetModel: AppointmentWidgetModel {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: SampleAppointmentWidgetModel, rhs: SampleAppointmentWidgetModel) -> Bool {
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
