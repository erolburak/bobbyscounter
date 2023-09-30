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
					viewModel.decreaseCounterCount()
				} label: {
					Text("Minus")
						.frame(maxWidth: .infinity)
				}
				.disabled(viewModel.counterSelected.counter?.count == 0)
				.accessibilityIdentifier("MinusButton")

				Button {
					viewModel.increaseCounterCount()
				} label: {
					Text("Plus")
						.frame(maxWidth: .infinity)
				}
				.accessibilityIdentifier("PlusButton")
			}
			.frame(maxHeight: .infinity)
			.font(.system(size: 140.0))
		}
		.edgesIgnoringSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(viewModel.counterSelected.counter?.date.toRelative ?? "")
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
			SettingsView(viewModel: ViewModelDI.shared.settingsViewModel(counterSelected: viewModel.counterSelected))
				.modelContainer(DataController.shared.modelContainer)
		}
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .active:
				DataController.shared.updateModelContainer()
				viewModel.fetchCounter()
			case .background:
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
	ContentView(viewModel: ViewModelDI.shared.contentViewModel())
}
