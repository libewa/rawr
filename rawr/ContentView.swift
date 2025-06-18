//
//  ContentView.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var amount = 200.0
    @State private var isDeleting = false
    @State private var isProcessing = false

    private var totalToday: Double {
        items.filter({ Calendar.current.isDateInToday($0.timestamp) })
            .compactMap({ $0.amount }).reduce(0, +)
    }
    
    private func logWater(amount: Double) {
        withAnimation {
            let item = Item(timestamp: Date(), amount: amount)
            modelContext.insert(item)
            self.amount = 0
        }
    }

    var body: some View {
        VStack {
            Text("Welcome to Rawr!")
                .font(.title)
            Text("(Roughly Approximate Water Reminder)")
                .font(.subheadline)
            Divider()
            Spacer()
            //TODO: visualize drinking goal
            //TODO: create a notification for the user to drink water
            Text("You drank \(Int(totalToday)) ml today.")
            AmountSelectionView(amount: $amount)
            WaterLoggingButton(amount: $amount, action: logWater)
            Spacer()
            Button(role: .destructive) {
                isDeleting = true
            } label: {
                Label("Delete all entries", systemImage: "trash")
            }
            .fullScreenCover(isPresented: $isProcessing) {
                ProgressView("Deleting...")
            }
            .alert(
                "Do you really want to delete ALL entries?",
                isPresented: $isDeleting,
                actions: {
                    Button("Delete", role: .destructive) {
                        do {
                            isProcessing = true
                            try modelContext.delete(model: Item.self)
                            try modelContext.save()
                            while !items.isEmpty {
                                modelContext.delete(items.first!)
                                try modelContext.save()
                            }
                            isProcessing = false
                        } catch {
                            fatalError("Failed to delete items: \(error)")
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        isDeleting = false
                    }
                },
                message: {
                    Text("This action cannot be undone.")
                }
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
