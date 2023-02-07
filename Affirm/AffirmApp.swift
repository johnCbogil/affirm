//
//  AffirmApp.swift
//  Affirm
//
//  Created by John Bogil on 1/31/23.
//

import SwiftUI
import BackgroundTasks
import UserNotifications

@main
struct AffirmApp: App {
    @Environment(\.scenePhase) private var phase
    private let scheduleAffirmationsIdentifier = "myapprefresh"

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active: scheduleAppRefresh()
            default: break
            }
        }
        .backgroundTask(.appRefresh(scheduleAffirmationsIdentifier)) {
            // NOISE
            scheduleAffirmations()
        }
    }
    
    private func scheduleAffirmations() {
        var affirmationText = ["one", "two", "three"]
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let hours = generateHours()
        
        for i in 0...2 {
            let content = UNMutableNotificationContent()
            content.title = affirmationText.randomElement()!
            affirmationText.removeAll(where: { $0 == content.title })
            
            var date = DateComponents()
            date.hour = hours[i]
            date.minute = Int.random(in: 0...59)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            print(request)
        }
    }
    
    private func generateHours() -> [Int] {
        var output = [Int]()
        output.append(Int.random(in: 8...12))
        output.append(Int.random(in: 13...17))
        output.append(Int.random(in: 18...22))
        return output
    }
    
    private func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: scheduleAffirmationsIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600) // 1 hours from now
        try! BGTaskScheduler.shared.submit(request)
    }
}
