//
//  rawrApp.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftData
import SwiftUI

@main
struct RawrApp: App {
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
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}
