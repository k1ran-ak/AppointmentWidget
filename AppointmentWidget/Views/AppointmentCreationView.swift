//
//  AppointmentCreationView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 15/07/25.
//

import SwiftUI

struct AppointmentCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: EventViewModel
    
    init(vm: EventViewModel) {
        self.viewModel = vm
//        _selectedService = State(initialValue: vm.draft.service.first)
        _selectedGuests = State(initialValue: Set(vm.guests))
        _selectedDate = State(initialValue: vm.draft.zuluStartDate ?? Date())
        _startTime = State(initialValue: vm.draft.zuluStartDate ?? Date())
        _endTime = State(initialValue: vm.draft.zuluEndDate ?? Date())
        _notes = State(initialValue: vm.draft.notes ?? "")
        _selectedLabel = State(initialValue: vm.draft.label ?? "")
        _providerName = State(initialValue: vm.draft.createdBy ?? "")
    }
    
    // MARK: - State Variables
    @State private var selectedService: String?
    @State private var selectedGuests: Set<String> = []
    @State private var selectedProviders: Set<String> = []
    @State private var selectedDate = Date()
    @State private var startTime = Calendar.current.date(bySettingHour: 10, minute: 15, second: 0, of: Date()) ?? Date()
    @State private var endTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date()
    @State private var notes = ""
    @State private var videoLink = ""
    @State private var selectedLabel = "No label"
    @State private var providerName = "Anush Kiran"
    
    // MARK: - UI State
    @State private var showingServiceDropdown = false
    @State private var showingGuestDropdown = false
    @State private var showingProviderDropdown = false
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var showingRepeatOptions = false
    @State private var showingVideoOptions = false
    
    // MARK: - Search States
    @State private var serviceSearchText = ""
    @State private var guestSearchText = ""
    @State private var providerSearchText = ""
    
    // MARK: - Validation States
    @State private var showServiceError = false
    @State private var showGuestError = false
    
    // MARK: - Computed Properties
    private var filteredServices: [MeetingType] {
        if serviceSearchText.isEmpty {
            return testMeetingTypes
        } else {
            return testMeetingTypes.filter { $0.name.lowercased().contains(serviceSearchText.lowercased()) }
        }
    }
    
    private var filteredGuests: [Guest] {
        let allGuests = testGuests + testProvidersAsGuest
        if guestSearchText.isEmpty {
            return allGuests
        } else {
            return allGuests.filter { $0.name.lowercased().contains(guestSearchText.lowercased()) }
        }
    }
    
    private var filteredProviders: [Provider] {
        if providerSearchText.isEmpty {
            return testProviders
        } else {
            return testProviders.filter { $0.name.lowercased().contains(providerSearchText.lowercased()) }
        }
    }
    
    private var canCreate: Bool {
        selectedService != nil && !selectedGuests.isEmpty
    }
    
    private var timeRangeText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
    
    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Main Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Service Selection
                    serviceSelectionView
                    
                    // Date and Time
                    dateTimeView
                    
                    // Guest Selection
                    guestSelectionView
                    
                    // Provider Selection
//                    providerSelectionView
                    
                    // Video Link
                    videoLinkView
                    
                    // Notes
                    notesView
                    
                    // User Info
                    userInfoView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Space for create button
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            // Create Button
            VStack {
                Spacer()
                createButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        )
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            
            // Tabs
            HStack(spacing: 20) {
                ForEach(["Service", "Class", "Event"], id: \.self) { tab in
                    VStack(spacing: 4) {
                        Text(tab)
                            .font(.subheadline)
                            .foregroundColor(tab == "Service" ? .primary : .secondary)
                        
                        if tab == "Service" {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Label Dropdown
            Menu {
                ForEach(labels, id: \.self) { label in
                    Button(label) {
                        selectedLabel = label
                    }
                }
            } label: {
                HStack {
                    Text(selectedLabel)
                        .font(.subheadline)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
//            Button(action: {
//                dismiss()
//            }) {
//                Image(systemName: "xmark")
//                    .font(.title2)
//                    .foregroundColor(.secondary)
//            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    // MARK: - Service Selection View
    private var serviceSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(selectedService != nil ? serviceColor(for: selectedService!) : Color.gray)
                    .frame(width: 8, height: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedService ?? "Select a service")
                        .font(.body)
                        .foregroundColor(selectedService == nil ? .secondary : .primary)
                    
                    if let service = selectedService {
                        HStack {
                            Text(serviceDuration(for: service))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if let price = servicePrice(for: service) {
                                Text(price)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showServiceError ? Color.red : Color(.systemGray4), lineWidth: 1)
            )
            .onTapGesture {
                showingServiceDropdown.toggle()
            }
            
            if showingServiceDropdown {
                VStack(spacing: 0) {
                    // Search field
                    TextField("Search services...", text: $serviceSearchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    // Service list
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredServices, id: \.id) { service in
                                serviceRowView(service)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding(.top, 4)
            }
            
            if showServiceError {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Select at least one service to continue")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.leading, 16)
            }
        }
    }
    
    private func serviceRowView(_ service: MeetingType) -> some View {
        HStack {
            Circle()
                .fill(serviceColor(for: service.name))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(service.name)
                    .font(.body)
                
                HStack {
                    Text(serviceDuration(for: service.name))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let price = servicePrice(for: service.name) {
                        Text(price)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .onTapGesture {
            selectedService = service.name
            showingServiceDropdown = false
            showServiceError = false
        }
    }
    
    // MARK: - Date and Time View
    private var dateTimeView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(dateText)
                            .font(.body)
                        
                        
                        Text(timeRangeText)
                            .font(.body)
                    }
                    
                    HStack {
                        Text("Does not repeat")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onTapGesture {
                showingDatePicker = true
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            dateTimePickerSheet
        }
    }
    
    private var dateTimePickerSheet: some View {
        NavigationView {
            VStack(spacing: 10) {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                HStack {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Select Date & Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingDatePicker = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingDatePicker = false
                    }
                }
            }
        }
    }
    
    // MARK: - Guest Selection View
    private var guestSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.secondary)
                
                Text(selectedGuests.isEmpty ? "Add guest(s)" : "\(selectedGuests.count) guest(s) selected")
                    .font(.body)
                    .foregroundColor(selectedGuests.isEmpty ? .secondary : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showGuestError ? Color.red : Color(.systemGray4), lineWidth: 1)
            )
            .onTapGesture {
                showingGuestDropdown.toggle()
            }
            
            if showingGuestDropdown {
                VStack(spacing: 0) {
                    HStack {
                        // Search field
                        TextField("Search guests...", text: $guestSearchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        Button {
                            showingGuestDropdown = false
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                        }

                    }
                    
                    // Guest list
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredGuests, id: \.id) { guest in
                                guestRowView(guest)
                            }
                            
                            // Add new customer option
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                                Text("+ Add new customer")
                                    .font(.body)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding(.top, 4)
            }
            
            if showGuestError {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Add at least one guest to continue")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.leading, 16)
            }
        }
    }
    
    private func guestRowView(_ guest: Guest) -> some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(guest.name.prefix(1)).uppercased())
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(guest.name)
                    .font(.body)
                
                if let email = guest.email {
                    Text(email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if guest.isProvider {
                    Text("Provider")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if selectedGuests.contains(guest.name) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .onTapGesture {
            if selectedGuests.contains(guest.name) {
                selectedGuests.remove(guest.name)
            } else {
                selectedGuests.insert(guest.name)
            }
            showGuestError = false
        }
    }
    
    // MARK: - Provider Selection View
    private var providerSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.badge.plus")
                    .foregroundColor(.secondary)
                
                Text(selectedProviders.isEmpty ? "Add provider(s)" : "\(selectedProviders.count) provider(s) selected")
                    .font(.body)
                    .foregroundColor(selectedProviders.isEmpty ? .secondary : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onTapGesture {
                showingProviderDropdown.toggle()
            }
            
            if showingProviderDropdown {
                VStack(spacing: 0) {
                    HStack {
                        // Search field
                        TextField("Search providers...", text: $providerSearchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        Button {
                            showingProviderDropdown = false
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                        }
                    }
                    
                    // Provider list
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredProviders, id: \.id) { provider in
                                providerRowView(provider)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding(.top, 4)
            }
        }
    }
    
    private func providerRowView(_ provider: Provider) -> some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(provider.name.prefix(1)).uppercased())
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(provider.name)
                    .font(.body)
                
                Text("Provider")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if selectedProviders.contains(provider.name) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .onTapGesture {
//            if selectedProviders.contains(provider.name) {
//                selectedProviders.remove(provider.name)
//            } else {
//                selectedProviders.insert(provider.name)
//            }
            providerName = provider.name
            showingProviderDropdown = false
        }
    }
    
    // MARK: - Video Link View
    private var videoLinkView: some View {
        HStack {
            Image(systemName: "video")
                .foregroundColor(.secondary)
            
            Text("Add video link")
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .onTapGesture {
            showingVideoOptions = true
        }
    }
    
    // MARK: - Notes View
    private var notesView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.secondary)
                
                Text("Notes to provider and guest(s)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            TextEditor(text: $notes)
                .frame(minHeight: 80)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    // MARK: - User Info View
    private var userInfoView: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("\(providerName.first ?? "A")")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                Text(providerName)
                    .font(.body)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onTapGesture {
                showingProviderDropdown.toggle()
            }
            
            if showingProviderDropdown {
                VStack(spacing: 0) {
                    HStack {
                        // Search field
                        TextField("Search providers...", text: $providerSearchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        Button {
                            showingProviderDropdown = false
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                        }
                    }
                    
                    // Provider list
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredProviders, id: \.id) { provider in
                                providerRowView(provider)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Create Button
    private var createButton: some View {
        Button(action: {
            validateAndCreate()
        }) {
            Text("Create")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black)
                .cornerRadius(12)
        }
//        .disabled(!canCreate)
        .opacity(canCreate ? 1.0 : 0.6)
    }
    
    // MARK: - Helper Functions
    private func validateAndCreate() {
        var hasError = false
        
        if selectedService == nil {
            showServiceError = true
            hasError = true
        }
        
        if selectedGuests.isEmpty {
            showGuestError = true
            hasError = true
        }
        
        if !hasError {
            // Create appointment logic here
            print("Creating appointment with:")
            print("Service: \(selectedService ?? "")")
            print("Guests: \(Array(selectedGuests))")
            print("Providers: \(Array(selectedProviders))")
            print("Date: \(selectedDate)")
            print("Time: \(timeRangeText)")
            print("Notes: \(notes)")
        }
    }
    
    private func serviceColor(for serviceName: String) -> Color {
        switch serviceName {
        case testMeetingTypes[0].name:
            return .red
        case testMeetingTypes[1].name:
            return .yellow
        case testMeetingTypes[2].name:
            return .red
        default:
            return .gray
        }
    }
    
    private func serviceDuration(for serviceName: String) -> String {
        switch serviceName {
        case testMeetingTypes[0].name:
            return "30 mins"
        case testMeetingTypes[1].name:
            return "15 mins"
        case testMeetingTypes[2].name:
            return "60 mins"
        default:
            return "30 mins"
        }
    }
    
    private func servicePrice(for serviceName: String) -> String? {
        switch serviceName {
        case testMeetingTypes[0].name:
            return "£1"
        case testMeetingTypes[1].name:
            return nil
        case testMeetingTypes[2].name:
            return nil
        default:
            return nil
        }
    }
}

#Preview {
    NavigationView {
        AppointmentCreationView(vm: EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
            .navigationBarHidden(true)
    }
}
