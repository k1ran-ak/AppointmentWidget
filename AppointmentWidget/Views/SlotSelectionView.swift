//
//  SlotSelectionView.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 21/07/25.
//

import SwiftUI
import Foundation

struct SlotSelectionView: View {
    @State var selectedDate: Date = Date()
    @State var selectedSlot: Date?
    @State var size: Int = 60
    private var gridItems = Array(repeating: GridItem(), count: 3)
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var eventSession: EventViewModel
    
    let formatter = DateFormatter()
    
    init(selectedDate: Date, size: Int, selectedSlot: Date?, gridItems: [GridItem] = Array(repeating: GridItem(), count: 3)) {
        self.selectedDate = selectedDate
        self.size = size
        self.gridItems = gridItems
        self.selectedSlot = selectedSlot
        formatter.dateFormat = "h:mm a"
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .padding()
            
            HStack {
                Text("Select Size")
                Spacer()
                Picker("Select Size", selection: $size) {
                    Text("15 mins").tag(15)
                    Text("30 mins").tag(30)
                    Text("60 mins").tag(60)
                }
            }
            .padding([.bottom, .horizontal])
           
            Spacer()
            
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 30) {
                    
                    let dates = splitDate(selectedDate, size: size)
                    
                    ForEach(dates, id: \.timeIntervalSince1970) { date in
                        Text(formatter.string(from: date))
                            .padding()
                            .capsuleBorder(isSelected: selectedSlot == date)
                            .onTapGesture {
                                selectedSlot = date
                            }
                    }
                }
            }
            
            // Continue button
            if selectedSlot != nil {
                Button("Continue") {
                    eventSession.draft.zuluStartDate = selectedSlot!
                    eventSession.draft.zuluEndDate = selectedSlot!.addingTimeInterval(Double(size * 60))
                    eventSession.draft.startTime = selectedSlot!.timeIntervalSince1970
                    eventSession.draft.endTime = selectedSlot!.addingTimeInterval(Double(size * 60)).timeIntervalSince1970
                    let nextView = eventSession.getNextView(current: .slotList)
                    navigator.push(nextView)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle("Select Slot")
        .withChevronBack()
    }
    
    
    private func splitDate(_ date: Date, size minutes: Int) -> [Date] {
        let calendar = Calendar.current
     
        let startOfDay = calendar.startOfDay(for: date)
   
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }

        var slots: [Date] = []
        var current = startOfDay
        while current < nextDay {
            slots.append(current)
            guard let next = calendar.date(byAdding: .minute, value: minutes, to: current) else {
                break
            }
            current = next
        }
        return slots
    }

}

#Preview {
    SlotSelectionView(selectedDate: Date(), size: 15, selectedSlot: nil)
        .environmentObject(Navigator())
        .environmentObject(EventViewModel(model: mockEventModel, sessionUserId: testProviders[0].name))
}
