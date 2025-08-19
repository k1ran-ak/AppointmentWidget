//
//  AppointmentView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 07/07/25.
//


import SwiftUI

struct AppointmentView: View {
    var body: some View {
        NavigationView {
            Form {
                // Service
                HStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 12, height: 12)
                    VStack(alignment: .leading) {
                        Text("Service")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Meeting Dermatologist - [Video meeting]")
                            .font(.body)
                    }
                    Spacer()
                }
                
                // Cost, Duration, Buffer
                HStack {
                    VStack(alignment: .leading) {
                        Text("Cost")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("AED 0")
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("30 minutes")
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Buffer")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("30 minutes")
                    }
                }
                
                // Date
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Sat 5 Jul 2025 · 8:00 AM - 9:00 AM")
                    }
                }
                
                // Repeat
                HStack {
                    Image(systemName: "arrow.2.circlepath")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Repeat")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Does not repeat")
                    }
                }
                
                // Guest
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Select guest(s)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 36, height: 36)
                                .overlay(Text("PN").font(.headline))
                            VStack(alignment: .leading) {
                                Text("Phone Number Alone")
                                Text("+917725566233")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // Add video link
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.gray)
                    Text("Add video link")
                        .foregroundColor(.gray)
                }
                
                // Notes
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(.gray)
                    Text("Notes to the provider and guest(s)")
                        .foregroundColor(.gray)
                }
                
                // Label
                HStack {
                    Image(systemName: "tag")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Add label")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Paid")
                    }
                }
                
                // Calendar
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Calendar")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("KIRAN")
                    }
                }
            }
            .navigationBarTitle("Appointment", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {})
        }
    }
}

struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView()
    }
}