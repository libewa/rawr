//
//  LogWaterAppIntent.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import AppIntents
import SwiftData
import WidgetKit

struct LogWaterAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Water"
    static var description: IntentDescription = "Log a specific amount of water."
    static var openAppWhenRun = false
    
    @Parameter(title: "Amount", description: "The amount of water to log.", default: 200.0, controlStyle: .field)
    var amount: Double
    
    @MainActor func perform() async throws -> some IntentResult {
        let sharedModelContainer: ModelContainer = {
            let schema = Schema([
                Item.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
        let context = ModelContext(sharedModelContainer)
        context.insert(Item(timestamp: Date(), amount: amount))
        try! context.save()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
