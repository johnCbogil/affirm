//
//  HomeView.swift
//  Affirm
//
//  Created by John Bogil on 1/31/23.
//

import SwiftUI
import UserNotifications

struct HomeView: View {
    @ObservedObject var dataStore: DataStore

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
                    ForEach(dataStore.currentlyScheduledAffirmations, id: \.self) { text in
                        Text(text)
                    }
                }
                .navigationTitle("Currently Scheduled")
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
