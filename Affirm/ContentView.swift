//
//  ContentView.swift
//  Affirm
//
//  Created by John Bogil on 1/31/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    private let affirmationText = ["one", "two", "three"]
    var body: some View {
        VStack {
            Spacer()
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Spacer()

            Button("Schedule Notification") {
                generateHourlyNotification()
            }
            Spacer()
        }
    }
    
    private func generateNotificationRequests() {
        var timeInterval = 0
        
        for text in affirmationText {
            timeInterval += 1
            let content = UNMutableNotificationContent()
            content.title = text
            content.sound = UNNotificationSound.default
            
            var date = DateComponents()
            date.minute = 1
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func generateHourlyNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Hourly Notification"
        content.body = "This is an hourly notification"

        var date = DateComponents()
        date.minute = 1
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(identifier: "hourly_notification", content: content, trigger: trigger)
        center.add(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
