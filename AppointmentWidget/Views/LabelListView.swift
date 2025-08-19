//
//  LabelListView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 28/07/25.
//

import SwiftUI

struct LabelListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var session: EventViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach(labels, id: \.self) { label in
                    HStack(alignment: .top) {
                        circleImageView(label)
                        Text(label)
                            .font(.subheadline)
                        Spacer()
                    }
                    .onTapGesture {
                        session.draft.label = label
                        dismiss()
                    }
                    .padding()
                }
                Spacer()
            }
            .navigationTitle("Select label")
            .withChevronBack()
        }
    }
    
    @ViewBuilder func circleImageView(_ label: String) -> some View {
        if label == session.draft.label {
            Image(systemName: "circle.circle.fill")
        } else {
            Image(systemName: "circle")
        }
    }
}

#Preview {
    LabelListView()
        .environmentObject(Navigator())
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
}

let labels = ["Pending", "Confirmed", "Completed", "Started", "Paid", "No label"]
