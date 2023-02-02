//
//  ContentView.swift
//  Affirm
//
//  Created by John Bogil on 1/31/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
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

            Button("Schedule Affirmations") {
                scheduleAffirmations()
            }
            Spacer()
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
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
