//
//  HomeView.swift
//  Affirm
//
//  Created by John Bogil on 1/31/23.
//

import SwiftUI
import UserNotifications

struct HomeView: View {
    @State var currentlyScheduledAffirmations = [String]()
    
    init() {
        getCurrentlyScheduledAffirmations()
    }
    
    var body: some View {
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            NavigationStack {
                List {
                    ForEach(currentlyScheduledAffirmations, id: \.self) { text in
                        Text(text)
                    }
                }
                .navigationTitle("Currently Scheduled")
            }
        }
    }
    
    private func getCurrentlyScheduledAffirmations() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                let trigger = notification.trigger as! UNCalendarNotificationTrigger
                let createdAtDate = createDateTime(timestamp: Date().timeIntervalSince1970.debugDescription)
                let createdAt = "\(createdAtDate)"
                let scheduledForDate = createDateTime(timestamp: trigger.nextTriggerDate()!.timeIntervalSince1970.debugDescription)
                let scheduledFor = "\(scheduledForDate)"
                let content = notification.content.title
                let string = "CreatedAt: \(createdAt)\nScheduledFor: \(scheduledFor)\nContent: \(content)"
                self.currentlyScheduledAffirmations.insert(string, at: 0)
            }
        }
    }
    
    private func createDateTime(timestamp: String) -> String {
        var strDate = "undefined"
        
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation()!  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM.dd.yyyy h:mm a" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
        return strDate
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
