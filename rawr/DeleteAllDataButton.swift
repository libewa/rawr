//
//  DeleteAllDataButton.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import SwiftData
import SwiftUI

struct DeleteAllDataButton: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]
  @Binding var isDeleting: Bool
  @Binding var isProcessing: Bool
  var body: some View {
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
}

#Preview {
  @Previewable @State var isDeleting = false
  @Previewable @State var isProcessing = false
  DeleteAllDataButton(isDeleting: $isDeleting, isProcessing: $isProcessing)
}
