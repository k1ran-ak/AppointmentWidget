//
//  EditableAppointmentView 2.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 22/07/25.
//
import SwiftUI

struct EditableAppointmentView: View {

    // Alert flags
    @State private var showingSaveAlert = false
    @State private var showingDiscardAlert = false
    @State private var isSaving = false

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: EventViewModel
    @EnvironmentObject var navigator: Navigator

    // Local draft of the event we are editing
    @State private var draft: EventModel

    // MARK: Init
    init(session: EventViewModel) {
        _draft = State(initialValue: session.draft)
    }

    // MARK: Body
    var body: some View {
        Form {
            // MARK: Title Section
            Section(header: Text("Appointment Details")) {
                HStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 12, height: 12)
                    VStack(alignment: .leading) {
                        Text("Service name")
                            .font(.caption)
                            .foregroundColor(.gray)
//                        TextField("Enter appointment title",
//                                  text: binding(\.title, default: ""))
//                            .textFieldStyle(.roundedBorder)
                        Text(session.draft.service.first ?? "")
                       
                    }
                }
            }
            .onTapGesture {
                navigator.push(.appointmentList)
            }

            // MARK: Date & Time
            Section(header: Text("Date & Time")) {

                // Start
//                HStack {
//                    Image(systemName: "clock")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("Start Date & Time")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//
//                        DatePicker(
//                            "",
//                            selection: dateBinding(start: true),
//                            displayedComponents: [.date, .hourAndMinute]
//                        )
//                        .labelsHidden()
//                    }
//                }
//
//                // End
//                HStack {
//                    Image(systemName: "clock.badge")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("End Date & Time")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//
//                        DatePicker(
//                            "",
//                            selection: dateBinding(start: false),
//                            displayedComponents: [.date, .hourAndMinute]
//                        )
//                        .labelsHidden()
//                    }
//                }
                VStack {
                    LabelView(type: "Start Date & Time", value: session.draft.zuluStartDate?.formatted(date: .numeric, time: .shortened) ?? "")
                    LabelView(type: "End Date & Time", value: session.draft.zuluEndDate?.formatted(date: .numeric, time: .shortened) ?? "")
                }
            }
            .onTapGesture {
                navigator.push(.slotList)
            }

            // MARK: Cost & Seats
            Section(header: Text("Pricing & Capacity")) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Cost")
                            .font(.caption)
                            .foregroundColor(.gray)

//                        TextField("0.0",
//                                  text: numberStringBinding(\.cost))
//                            .textFieldStyle(.roundedBorder)
//                            .keyboardType(.decimalPad)
                        Text(draft.cost, format: .currency(code: "USD"))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Max Seats")
                            .font(.caption)
                            .foregroundColor(.gray)

//                        TextField("0",
//                                  text: intStringBinding(\.maxSeats))
//                            .textFieldStyle(.roundedBorder)
//                            .keyboardType(.numberPad)
                        Text("\(draft.maxSeats)")
                    }
                }
            }

            // MARK: Label
            Section(header: Text("Label")) {
                HStack {
                    Image(systemName: "tag")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Label")
                            .font(.caption)
                            .foregroundColor(.gray)
//                        TextField("Add label", text: binding(\.label, default: ""))
//                            .textFieldStyle(.roundedBorder)
                        Text(session.draft.label ?? "")
                    }
                }
            }
            .onTapGesture {
                navigator.present(.labelList)
            }
            
            Section(header: Text("Guest Details")) {
                HStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 12, height: 12)
                    VStack(alignment: .leading) {
                        Text("Guest count \(session.guests.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
//                        TextField("Enter appointment title",
//                                  text: binding(\.title, default: ""))
//                            .textFieldStyle(.roundedBorder)
                        ForEach(session.guests, id: \.self) { guests in
                            Text(guests)
                                .padding(2)
                        }
                    }
                }
            }
            .onTapGesture {
                navigator.push(.guestList)
            }

            // MARK: Notes
            Section(header: Text("Notes")) {
                HStack(alignment: .top) {
                    Image(systemName: "note.text")
                        .foregroundColor(.gray)
                    TextEditor(text: binding(\.notes, default: ""))
                        .frame(minHeight: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }
            }
            
            // MARK: Location
            Section(header: Text("Location")) {
                locationView
                    .onTapGesture {
                        navigator.push(.addressSelection)
                    }
            }
            
            // MARK: VideoMeet
            Section(header: Text("VideoMeet")) {
                videoMeetingView
                    .onTapGesture {
                        navigator.push(.videoMeetSelection)
                    }
            }

//            // MARK: Event Color
//            Section(header: Text("Appearance")) {
//                HStack {
//                    Image(systemName: "paintbrush")
//                        .foregroundColor(.gray)
//                    VStack(alignment: .leading) {
//                        Text("Event Color")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        TextField("Color code (e.g., #FF5733)",
//                                  text: binding(\.eventColor, default: ""))
//                            .textFieldStyle(.roundedBorder)
//                    }
//                }
//            }

//            // MARK: Read-only (if editing existing)
//            if !isNew {
//                Section(header: Text("Appointment Information")) {
//                    readOnlyRow(title: "Booking ID", value: draft.bookingId)
//                    readOnlyRow(title: "Payment Status", value: draft.paymentStatus)
//                    readOnlyRow(title: "Type", value: draft.type?.rawValue)
//                }
//            }
            
            // MARK: Host
            Section(header: Text("Host")) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Host")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(session.sessionUserId)
                    }
                }
            }
            .onTapGesture {
                navigator.push(.providerList(showAll: true))
            }
        }
        .navigationTitle(isNew ? "New Appointment" : "Edit Appointment")
        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button("Cancel") {
////                    if hasChanges {
////                        showingDiscardAlert = true
////                    } else {
////                        dismiss()
////                    }
//                    dismiss()
//                }
//            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    save()
                }
                    .disabled(isSaving)
            }
        }
        .alert("Appointment Saved", isPresented: $showingSaveAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your appointment has been saved successfully.")
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                draft = session.draft
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("Are you sure you want to discard your changes?")
        }
        .onAppear {
            // Mark that we've reached the summary view
            session.hasReachedSummary = true
        }
        .withDismissButton {
            /// Exit to calendar
            /// Show discard changes popup
        }
    }

    // MARK: - Helpers
    
    @ViewBuilder var videoMeetingView: some View {
        if draft.location?.videoType == nil {
            HStack(alignment: .top) {
                Image(systemName: "video")
                    .foregroundColor(.gray)
                Text("Add a video link")
            }
        } else {
            HStack(alignment: .center) {
                Image(systemName: "video")
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(draft.location?.videoType?.first?.type.title ?? "")
                        .font(.headline)
                    Text(draft.location?.videoType?.first?.link?.absoluteString ?? "")
                        .font(.subheadline)
                }
            }
        }
    }
    
    @ViewBuilder var locationView: some View {
        if draft.location?.address == nil {
            HStack(alignment: .top) {
                Image(systemName: "location")
                    .foregroundColor(.gray)
                Text("Add location")
            }
        } else {
            HStack(alignment: .top) {
                Image(systemName: "location")
                    .foregroundColor(.gray)
                Text(draft.location?.address?.first?.addressLine1 ?? "")
            }
        }
    }

    private var isNew: Bool { session.original.id.isEmpty } // adapt your own logic
//    private var hasChanges: Bool { draft != session.current }

    /// Bind an optional String with a default fallback.
    private func binding(_ keyPath: WritableKeyPath<EventModel, String?>,
                         default def: String) -> Binding<String> {
        Binding<String>(
            get: { draft[keyPath: keyPath] ?? def },
            set: { draft[keyPath: keyPath] = $0.isEmpty ? nil : $0 }
        )
    }

    /// Bind a Double via a String textfield
    private func numberStringBinding(_ keyPath: WritableKeyPath<EventModel, Double>) -> Binding<String> {
        Binding<String>(
            get: { String(draft[keyPath: keyPath]) },
            set: { draft[keyPath: keyPath] = Double($0) ?? draft[keyPath: keyPath] }
        )
    }

    /// Bind an Int via a String textfield
    private func intStringBinding(_ keyPath: WritableKeyPath<EventModel, Int>) -> Binding<String> {
        Binding<String>(
            get: { String(draft[keyPath: keyPath]) },
            set: { draft[keyPath: keyPath] = Int($0) ?? draft[keyPath: keyPath] }
        )
    }

    /// Bind Date pickers, update ISO strings & millis as you do now.
    private func dateBinding(start: Bool) -> Binding<Date> {
        Binding<Date>(
            get: {
                if start {
                    return draft.zuluStartDate ?? Date()
                } else {
                    return draft.zuluEndDate ?? (draft.zuluStartDate ?? Date()).addingTimeInterval(3600)
                }
            },
            set: { new in
                if start {
                    draft.zuluStartDate  = new
                    draft.startDateTime  = isoFormatter.string(from: new)
                    draft.startTime      = new.timeIntervalSince1970 * 1000
                } else {
                    draft.zuluEndDate    = new
                    draft.endDateTime    = isoFormatter.string(from: new)
                    draft.endTime        = new.timeIntervalSince1970 * 1000
                }
            }
        )
    }

    private let isoFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private func readOnlyRow(title: String, value: String?) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value ?? "—")
            }
            Spacer()
        }
    }

    private func save() {
        isSaving = true
        Task {
            // Do API call here if needed
            await MainActor.run {
                session.apply(draft)
                isSaving = false
                showingSaveAlert = true
            }
            debugPrint(session.draft)
        }
    }
}

// MARK: - Preview

struct EditableAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = mockEventModel
        let session = EventViewModel(model: model, sessionUserId: testProviders[0].name)

        NavigationStack {
            EditableAppointmentView(session: session)
        }
        .environmentObject(session)
        .environmentObject(Navigator())
    }
}


var mockEventModel: EventModel = EventModel(
        id: "sample-123",
        calendar: "sample-cal",
        merchant: "sample-merchant",
        brand: .SetMore,
        type: .appointment,
        provider: [testProviders[0].name,  testProviders[1].name],
        service: [testMeetingTypes[0].name],
        consumer: testGuests.map({$0.name}),
        resource: [],
        startDateTime: "2025-01-15T10:00:00Z",
        endDateTime: "2025-01-15T11:00:00Z",
        zuluStartDate: Date(),
        zuluEndDate: Date().addingTimeInterval(3600),
        startTime: Date().timeIntervalSince1970 * 1000,
        endTime: Date().addingTimeInterval(3600).timeIntervalSince1970 * 1000,
        maxSeats: 2,
        cost: 150,
        isExternal: false,
        isDeleted: false,
        rRule: nil,
        paymentStatus: "PENDING",
        label: "Paid",
        bookingId: "BK-123456",
        source: "WIDGET",
        parentId: nil,
        title: "Sample Appointment",
        isAllDay: false,
        location: nil,
        metaData: nil,
        timezone: "UTC",
        notes: "Sample notes",
        createdBy: testProviders[0].name,
        createdTime: Date().timeIntervalSince1970 * 1000,
        updatedTime: Date().timeIntervalSince1970 * 1000,
        dayCount: nil,
        totalDaysCount: nil,
        isSlotCheck: false,
        slotParams: nil,
        videoIntegration: .zoom,
        exceptionDates: nil,
        eventColor: "#FF5733"
    )


struct LabelView: View {
    
    var type: String
    var value: String
    
    var body: some View {
        HStack {
            Text(type)
                .font(.subheadline)
                .foregroundColor(.primary)
            Text(value)
                .font(.caption)
            Spacer()
        }
        .padding()
        .capsuleBorder(isSelected: false)
        .padding()
    }
}
