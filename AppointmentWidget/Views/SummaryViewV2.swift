//
//  SummaryViewV2.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 13/08/25.
//

import SwiftUI

import SwiftUI

struct SummaryViewV2: View {

    // Alert flags
    @State private var showingSaveAlert = false
    @State private var showingDiscardAlert = false
    @State private var isSaving = false
    @State private var notes = ""

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: EventViewModel
    @EnvironmentObject var navigator: Navigator

    // Local draft of the event we are editing
    @State private var draft: EventModel

    // MARK: Init
    init(viewModel: EventViewModel) {
        _draft = State(initialValue: viewModel.draft)
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
                        Text(session.draft.service.first ?? "")
                    }
                }
            }
            .onTapGesture {
                navigator.push(.appointmentList)
            }

            // MARK: Date & Time
            Section(header: Text("Date & Time")) {
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
                        Text(draft.cost, format: .currency(code: "USD"))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Max Seats")
                            .font(.caption)
                            .foregroundColor(.gray)
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
                    TextEditor(text: $notes)
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

#Preview {
    let model = mockEventModel
    let viewModel = EventViewModel(model: model, sessionUserId: testProviders[0].name)
    SummaryViewV2(viewModel: viewModel)
        .environmentObject(viewModel)
        .environmentObject(Navigator())
}
