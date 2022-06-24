//
//  AsyncButton.swift
//  Elva
//
//  Created by Arthur Guiot on 6/23/22.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    var action: () async throws -> Void
    @ViewBuilder var label: () -> Label
    
    @State private var isPerformingTask = false
    @State private var showError = false
    @State private var error: TaskError? = nil
    
    enum TaskError: LocalizedError {
        case taskError(String)
        var errorDescription: String? {
            switch self {
            case .taskError(let str):
                return str
            }
        }
    }
    
    var body: some View {
        Button(
            action: {
                isPerformingTask = true
                
                Task {
                    do {
                        try await action()
                    } catch {
                        print(error)
                        self.error = TaskError.taskError(error.localizedDescription)
                        self.showError = true
                    }
                    isPerformingTask = false
                }
            },
            label: {
                ZStack {
                    // We hide the label by setting its opacity
                    // to zero, since we don't want the button's
                    // size to change while its task is performed:
                    label()
                        .frame(maxWidth: .infinity)
                        .opacity(isPerformingTask ? 0 : 1)
                    
                    if isPerformingTask {
                        ProgressView()
                            .controlSize(.mini)
                    }
                }
            }
        )
        .disabled(isPerformingTask)
        .alert(isPresented: $showError, error: error) {
            Button("Ok", role: .cancel) {
                showError.toggle()
            }
        }
    }
}
