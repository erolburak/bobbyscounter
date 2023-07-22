//
//  ContentView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftData
import SwiftUI
import WidgetKit

struct ContentView: View {

	// MARK: - Properties

	@Environment(\.scenePhase) private var scenePhase
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \.date, order: .forward) private var counters: [Counter]
	@State var viewModel: ContentViewModel

	// MARK: - Layouts

	var body: some View {
		ZStack {
			Text(viewModel.counter?.count.description ?? "0")
				.font(.system(size: 100000.0,
							  weight: .bold,
							  design: .monospaced))
				.minimumScaleFactor(0.001)
				.lineLimit(1)
				.opacity(0.25)

			HStack {
				Button {
					viewModel.decreaseCount()
				} label: {
					Text("Minus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
				.disabled(viewModel.counter?.count == 0)

				Button {
					viewModel.increaseCount()
				} label: {
					Text("Plus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
			}
		}
		.edgesIgnoringSafeArea(.all)
		.font(.system(size: 100.0,
					  weight: .bold,
					  design: .monospaced))
		.overlay(alignment: .topTrailing) {
			Text(viewModel.counter?.date.relative ?? "")
				.font(.system(size: 8,
							  weight: .bold,
							  design: .monospaced))
				.padding(.trailing)
		}
		.overlay(alignment: .bottom) {
			Button("Settings") {
				viewModel.showSettingsSheet.toggle()
			}
		}
		.sheet(isPresented: $viewModel.showSettingsSheet) {
			SettingsView(counter: $viewModel.counter,
						 selectedDate: $viewModel.selectedDate,
						 viewModel: SettingsViewModel())
		}
		.alert(isPresented: $viewModel.showAlert,
			   error: viewModel.alertError) { _ in
		} message: { error in
			if let message = error.recoverySuggestion {
				Text(message)
			}
		}
		.onAppear {
			Task {
				try await viewModel.setCounter(counters: counters)
			}
		}
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .active:
				/// Update counter count if scenePhase is active
				Task {
					try await viewModel.setCount()
				}
			case .background:
				/// Update widgets if scenePhase is background
				WidgetCenter.shared.reloadAllTimelines()
			default: break
			}
		}
		.tint(.accent)
	}
}

#Preview {
	ContentView(viewModel: ContentViewModel())
		.modelContainer(previewContainer)
}

@MainActor
private let previewContainer: ModelContainer = {
	do {
		let container = try ModelContainer(for: Counter.self,
										   ModelConfiguration(inMemory: true))
		container.mainContext.insert(Counter.preview)
		return container
	} catch {
		fatalError("Failed to create container")
	}
}()
