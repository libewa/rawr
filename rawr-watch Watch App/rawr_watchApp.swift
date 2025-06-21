//
//  rawr_watchApp.swift
//  rawr-watch Watch App
//
//  Created by Linus Warnatz on 19.06.25.
//

import SwiftData
import SwiftUI

@main
struct RawrWatchApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
      Notification.self
    ])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )

    do {
      return try ModelContainer(
        for: schema,
        configurations: [modelConfiguration]
      )
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ContentView()
      }
    }
    .modelContainer(sharedModelContainer)
  }
}
