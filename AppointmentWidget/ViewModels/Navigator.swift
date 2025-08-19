//
//  Navigator.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 18/07/25.
//


import SwiftUI

final class Navigator: ObservableObject {
    /// The stack path for push-navigation
    @Published var path: [Screen] = []
    /// The currently-presented sheet, if any
    @Published var sheet: Screen?
    
    // MARK: Push/pop
    func push(_ screen: Screen) {
        
        path.append(screen)
        print("🔵 after: ", path)
    }
    func pop() {
        _ = path.popLast()
    }
    func popToRoot() {
        path.removeAll()
    }
    
    // MARK: Present/dismiss
    func present(_ screen: Screen) {
        sheet = screen
    }
    
    func dismiss() {
        sheet = nil
    }
    
    // MARK: Reset navigation
    func resetToSummary() {
        // Clear the navigation stack and make summary the root
        path.removeAll()
        print("🔄 Navigator reset to summary")
    }
}
