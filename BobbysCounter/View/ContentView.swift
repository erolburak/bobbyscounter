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
	@Query(sort: \Counter.date,
		   order: .forward) private var counters: [Counter]
	@State var viewModel: ContentViewModel

	// MARK: - Layouts

	var body: some View {
		ZStack {
			Text(viewModel.counter?.count.description ?? "0")
				.font(.system(size: 1000))
				.minimumScaleFactor(0.001)
				.lineLimit(1)
				.opacity(0.25)
				.padding()
				.accessibilityIdentifier("CountText")

			HStack {
				Button {
					viewModel.decreaseCount()
				} label: {
					Text("Minus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
				.disabled(viewModel.counter?.count == 0)
				.accessibilityIdentifier("MinusButton")

				Button {
					viewModel.increaseCount()
				} label: {
					Text("Plus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
				.accessibilityIdentifier("PlusButton")
			}
			.font(.system(size: 140.0))
		}
		.edgesIgnoringSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(viewModel.counter?.date.relative ?? "")
				.font(.system(size: 8))
				.padding(.trailing)
				.accessibilityIdentifier("DateText")
		}
		.overlay(alignment: .bottom) {
			Button("Settings") {
				viewModel.showSettingsSheet.toggle()
			}
			.accessibilityIdentifier("SettingsButton")
		}
		.sheet(isPresented: $viewModel.showSettingsSheet) {
			SettingsView(counter: $viewModel.counter,
						 selectedDate: $viewModel.selectedDate,
						 viewModel: SettingsViewModel())
			.modelContainer(for: Counter.self)
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
				/// Fetch counter on appear
				try await viewModel.fetchCounter()
			}
		}
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .active:
				/// Fetch counter if scene phase is active
				Task {
					try await viewModel.fetchCounter()
				}
			case .background:
				/// Update widgets if scene phase is background
				WidgetCenter.shared.reloadAllTimelines()
			default: break
			}
		}
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.accent)
	}
}

#Preview {
	ContentView(viewModel: ContentViewModel())
		.modelContainer(for: Counter.self,
						inMemory: true)
}
