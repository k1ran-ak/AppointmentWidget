////
////  SimpleAppointmentListView.swift
////  AppointmentWidget
////
////  Created by Anush Kiran on 10/07/25.
////
//
//import SwiftUI
//
///// Simple appointment list view with search functionality
//struct SimpleAppointmentListView: View {
//    @State private var appointments: [AppointmentWidgetModel] = []
//    @State private var searchText = ""
//    @State private var isLoading = false
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Search Bar
//                searchBar
//                
//                // List Content
//                if isLoading {
//                    ProgressView("Loading appointments...")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else if filteredAppointments.isEmpty {
//                    emptyStateView
//                } else {
//                    List(filteredAppointments, id: \.id) { appointment in
//                        AppointmentRowView(appointment: appointment)
//                    }
//                    .listStyle(PlainListStyle())
//                }
//            }
//            .navigationTitle("Appointments")
//            .navigationBarItems(trailing: Button("Add") {
//                // Handle add appointment
//            })
//        }
//        .onAppear {
//            loadAppointments()
//        }
//    }
//    
//    // MARK: - Computed Properties
//    
//    private var filteredAppointments: [AppointmentWidgetModel] {
//        if searchText.isEmpty {
//            return appointments
//        } else {
//            return appointments.filter { appointment in
//                let searchableText = [
//                    appointment.title,
//                    appointment.label,
//                    appointment.notes
//                ].compactMap { $0 }.joined(separator: " ")
//                
//                return searchableText.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//    
//    // MARK: - Search Bar
//    
//    private var searchBar: some View {
//        HStack {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.gray)
//                
//                TextField("Search appointments...", text: $searchText)
//                    .textFieldStyle(PlainTextFieldStyle())
//                
//                if !searchText.isEmpty {
//                    Button(action: {
//                        searchText = ""
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding(.horizontal, 12)
//            .padding(.vertical, 8)
//            .background(Color(.systemGray6))
//            .cornerRadius(10)
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 8)
//        .background(Color(.systemBackground))
//    }
//    
//    // MARK: - Empty State
//    
//    private var emptyStateView: some View {
//        VStack(spacing: 16) {
//            Image(systemName: searchText.isEmpty ? "calendar.badge.plus" : "magnifyingglass")
//                .font(.system(size: 50))
//                .foregroundColor(searchText.isEmpty ? .blue : .gray)
//            
//            Text(searchText.isEmpty ? "No Appointments" : "No Results Found")
//                .font(.title2)
//                .fontWeight(.medium)
//                .foregroundColor(.primary)
//            
//            Text(searchText.isEmpty ? "Create your first appointment to get started." : "Try adjusting your search terms.")
//                .font(.body)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 32)
//            
//            if searchText.isEmpty {
//                Button("Create Appointment") {
//                    // Handle create appointment
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemGroupedBackground))
//    }
//    
//    // MARK: - Data Loading
//    
//    private func loadAppointments() {
//        isLoading = true
//        
//        // Simulate API call
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.appointments = self.createSampleAppointments()
//            self.isLoading = false
//        }
//    }
//    
//    private func createSampleAppointments() -> [AppointmentWidgetModel] {
//        return [
//            SampleAppointmentWidgetModel(
//                id: "1",
//                calendar: "work",
//                merchantId: "merchant123",
//                brand: .SetMore,
//                type: .appointment,
//                isExternal: false,
//                isDeleted: false,
//                paymentStatus: "PENDING",
//                bookingId: "BK-001",
//                source: "WIDGET",
//                parendId: nil,
//                isAllDay: false,
//                metaData: nil,
//                createdTime: Date().timeIntervalSince1970 * 1000,
//                updatedTime: Date().timeIntervalSince1970 * 1000,
//                dayCount: nil,
//                totalDaysCount: nil,
//                provider: ["Dr. Smith"],
//                service: ["Consultation"],
//                consumer: ["John Doe"],
//                startDateTime: "2025-01-15T10:00:00Z",
//                endDateTime: "2025-01-15T11:00:00Z",
//                zuluStartDate: Date().addingTimeInterval(3600),
//                zuluEndDate: Date().addingTimeInterval(7200),
//                startTime: Date().addingTimeInterval(3600).timeIntervalSince1970 * 1000,
//                endTime: Date().addingTimeInterval(7200).timeIntervalSince1970 * 1000,
//                maxSeats: 1,
//                cost: 150.0,
//                rRule: nil,
//                label: "Paid",
//                title: "Dental Checkup",
//                location: nil,
//                timezone: "UTC",
//                notes: "Regular dental checkup appointment",
//                createdBy: "user123",
//                isSlotChecked: false,
//                slotParams: nil,
//                exceptionDates: nil,
//                eventColor: "#FF5733"
//            ),
//            SampleAppointmentWidgetModel(
//                id: "2",
//                calendar: "personal",
//                merchantId: "merchant123",
//                brand: .SetMore,
//                type: .appointment,
//                isExternal: false,
//                isDeleted: false,
//                paymentStatus: "COMPLETED",
//                bookingId: "BK-002",
//                source: "WIDGET",
//                parendId: nil,
//                isAllDay: false,
//                metaData: nil,
//                createdTime: Date().timeIntervalSince1970 * 1000,
//                updatedTime: Date().timeIntervalSince1970 * 1000,
//                dayCount: nil,
//                totalDaysCount: nil,
//                provider: ["Dr. Johnson"],
//                service: ["Therapy"],
//                consumer: ["Jane Smith"],
//                startDateTime: "2025-01-16T14:00:00Z",
//                endDateTime: "2025-01-16T15:00:00Z",
//                zuluStartDate: Date().addingTimeInterval(86400 + 14400),
//                zuluEndDate: Date().addingTimeInterval(86400 + 18000),
//                startTime: Date().addingTimeInterval(86400 + 14400).timeIntervalSince1970 * 1000,
//                endTime: Date().addingTimeInterval(86400 + 18000).timeIntervalSince1970 * 1000,
//                maxSeats: 1,
//                cost: 200.0,
//                rRule: nil,
//                label: "Completed",
//                title: "Therapy Session",
//                location: nil,
//                timezone: "UTC",
//                notes: "Weekly therapy session",
//                createdBy: "user456",
//                isSlotChecked: false,
//                slotParams: nil,
//                exceptionDates: nil,
//                eventColor: "#4CAF50"
//            ),
//            SampleAppointmentWidgetModel(
//                id: "3",
//                calendar: "work",
//                merchantId: "merchant123",
//                brand: .SetMore,
//                type: .appointment,
//                isExternal: false,
//                isDeleted: false,
//                paymentStatus: "PENDING",
//                bookingId: "BK-003",
//                source: "WIDGET",
//                parendId: nil,
//                isAllDay: false,
//                metaData: nil,
//                createdTime: Date().timeIntervalSince1970 * 1000,
//                updatedTime: Date().timeIntervalSince1970 * 1000,
//                dayCount: nil,
//                totalDaysCount: nil,
//                provider: ["Team Lead"],
//                service: ["Meeting"],
//                consumer: ["Team Members"],
//                startDateTime: "2025-01-17T09:00:00Z",
//                endDateTime: "2025-01-17T10:00:00Z",
//                zuluStartDate: Date().addingTimeInterval(172800 + 32400),
//                zuluEndDate: Date().addingTimeInterval(172800 + 36000),
//                startTime: Date().addingTimeInterval(172800 + 32400).timeIntervalSince1970 * 1000,
//                endTime: Date().addingTimeInterval(172800 + 36000).timeIntervalSince1970 * 1000,
//                maxSeats: 5,
//                cost: 0.0,
//                rRule: nil,
//                label: "Team",
//                title: "Weekly Standup",
//                location: nil,
//                timezone: "UTC",
//                notes: "Daily team standup meeting",
//                createdBy: "user789",
//                isSlotChecked: false,
//                slotParams: nil,
//                exceptionDates: nil,
//                eventColor: "#2196F3"
//            )
//        ]
//    }
//}
//
///// Row view for individual appointment items
//struct AppointmentRowView: View {
//    let appointment: AppointmentWidgetModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(appointment.title ?? "Untitled Appointment")
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                    
//                    if let label = appointment.label {
//                        Text(label)
//                            .font(.caption)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 2)
//                            .background(Color.blue.opacity(0.1))
//                            .foregroundColor(.blue)
//                            .cornerRadius(4)
//                    }
//                }
//                
//                Spacer()
//                
//                VStack(alignment: .trailing) {
//                    Text(formatCurrency(appointment.cost))
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                        .foregroundColor(.primary)
//                    
//                    Text(appointment.paymentStatus ?? "Unknown")
//                        .font(.caption)
//                        .foregroundColor(paymentStatusColor)
//                }
//            }
//            
//            HStack {
//                Image(systemName: "clock")
//                    .foregroundColor(.gray)
//                    .font(.caption)
//                
//                Text(formatDateTime(appointment.zuluStartDate))
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                
//                Spacer()
//                
//                Text("\(appointment.maxSeats) seat\(appointment.maxSeats == 1 ? "" : "s")")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            
//            if let notes = appointment.notes, !notes.isEmpty {
//                Text(notes)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .lineLimit(2)
//            }
//        }
//        .padding(.vertical, 4)
//    }
//    
//    private func formatCurrency(_ amount: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.currencyCode = "USD"
//        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
//    }
//    
//    private func formatDateTime(_ date: Date?) -> String {
//        guard let date = date else { return "No date" }
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//    
//    private var paymentStatusColor: Color {
//        switch appointment.paymentStatus {
//        case "COMPLETED":
//            return .green
//        case "PENDING":
//            return .orange
//        case "CANCELLED":
//            return .red
//        default:
//            return .gray
//        }
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
//    
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
//
//// MARK: - Preview
//
//struct SimpleAppointmentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleAppointmentListView()
//    }
//} 
