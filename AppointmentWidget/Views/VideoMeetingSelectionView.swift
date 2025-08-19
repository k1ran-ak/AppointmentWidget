//
//  VideoMeetingSelectionView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 06/08/25.
//

import SwiftUI

struct VideoIntegration: Hashable, Identifiable {
    
    var id = UUID().uuidString
    let serviceList: [String]
    let name: VideoMeetType
    let staffList: [String]
    var isAccountLevel: Bool
}

let testVideoIntegrations = [
    VideoIntegration(serviceList: [testMeetingTypes[0].name],
                     name: .googleMeet,
                     staffList: testProviders.map({ $0.name}),
                     isAccountLevel: true),
    VideoIntegration(serviceList: [testMeetingTypes[1].name],
                     name: .teleport,
                     staffList: [testProviders[1].name],
                     isAccountLevel: false),
    VideoIntegration(serviceList: [testMeetingTypes[2].name],
                     name: .zoom,
                     staffList: [testProviders[2].name],
                     isAccountLevel: false),
]

struct VideoMeetingSelectionView: View {
    
    @EnvironmentObject var session: EventViewModel
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        VStack {
            Text("Select Video Integration")
                .font(.headline)
            ForEach(testVideoIntegrations) { videoIntegration in
                HStack(spacing: 16.0) {
                    Group {
                        Image(systemName: "video")
                        VStack(alignment: .leading, spacing: 4) {
                            Text(videoIntegration.name.title)
                                .lineLimit(1)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(height: 20.0)
                }
                .onTapGesture {
                    session.videoIntegration = videoIntegration
                    navigator.pop()
                }
            }
            .padding(16.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .withChevronBack()
    }
}

#Preview {
    VideoMeetingSelectionView()
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
        .environmentObject(Navigator())
}
