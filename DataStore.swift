//
//  DataStore.swift
//  Affirm
//
//  Created by John Bogil on 2/3/23.
//
import Foundation
import UserNotifications

class DataStore: ObservableObject {
    @Published var currentlyScheduledAffirmations = [String]()
    
    init() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] notifications in
            guard let self = self else { return }
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
        
        func createDateTime(timestamp: String) -> String {
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
}
