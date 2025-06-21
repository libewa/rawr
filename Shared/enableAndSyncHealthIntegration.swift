//
//  HealthIntegrationSync.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import HealthKit
import SwiftData
import SwiftUI

@MainActor
extension ContentView {
  func enableAndSyncHealthIntegration(types: Set<HKQuantityType>) async throws {
    // Check that Health data is available on the device.
    if HKHealthStore.isHealthDataAvailable() {
      let store = HKHealthStore()
      // Asynchronously request authorization to the data.
      try await store.requestAuthorization(toShare: types, read: types)

      for type in types {
        // Start by reading all matching data.
        var anchor: HKQueryAnchor?
        var results:
          HKAnchoredObjectQueryDescriptor<
            HKQuantitySample
          >.Result

        repeat {
          // Create a query descriptor that reads a batch
          // of 100 matching samples.
          let anchorDescriptor =
            HKAnchoredObjectQueryDescriptor(
              predicates: [
                .quantitySample(
                  type: type
                )
              ],
              anchor: anchor,
              limit: 100
            )

          results =
            try await anchorDescriptor.result(
              for: store
            )
          anchor = results.newAnchor

          for sample in results.addedSamples {
            let amount = sample.quantity.doubleValue(
              for: .literUnit(with: .milli)
            )
            if !items.contains(where: { $0.id == sample.uuid }) {
              print(
                "Added sample: \(sample.uuid) with amount: \(amount)"
              )
              context.insert(
                Item(
                  timestamp: sample.startDate,
                  amount: amount,
                  id: sample.uuid
                )
              )
            } else {
              print("Sample already exists: \(sample.uuid)")
            }
          }
          /*
          for sample in results.deletedObjects {
              try context.delete(
                  model: Item.self,
                  where: #Predicate<Item> { $0.id == sample.uuid }
              )
          }
           */

        } while results.addedSamples != []
          && results.deletedObjects != []
      }
    }
  }
}
