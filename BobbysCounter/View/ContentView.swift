//
//  ContentView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {

	// MARK: - Properties

	@State var viewModel: ContentViewModel

	// MARK: - Private Properties

	@Environment(\.scenePhase) private var scenePhase

	// MARK: - Layouts

	var body: some View {
		ZStack {
			Text(viewModel.counterSelected.counter?.count.description ?? "0")
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
				.disabled(viewModel.counterSelected.counter?.count == 0)
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
			Text(viewModel.counterSelected.counter?.date.relative ?? "")
				.font(.system(size: 8))
				.padding(.trailing)
				.accessibilityIdentifier("DateText")
		}
		.overlay(alignment: .bottom) {
			Button("Settings") {
				viewModel.showSettingsSheet = true
			}
			.padding(.bottom)
			.accessibilityIdentifier("SettingsButton")
		}
		.sheet(isPresented: $viewModel.showSettingsSheet) {
			SettingsView(viewModel: SettingsViewModel(counterSelected: viewModel.counterSelected))
				.modelContainer(Repository.shared.modelContainer)
		}
		.alert(isPresented: $viewModel.showAlert,
			   error: viewModel.alertError) { _ in
		} message: { error in
			if let message = error.recoverySuggestion {
				Text(message)
			}
		}
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .active:
				/// Update model container and fetch counter if scene phase is active
				Task {
					Repository.shared.updateModelContainer()
					await viewModel.fetchCounter()
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
}
