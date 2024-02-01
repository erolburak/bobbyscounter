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

	// MARK: - Private Properties

	@Environment(\.scenePhase) private var scenePhase
	@Environment(Alert.self) private var alert
	@Environment(Sensory.self) private var sensory
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var selected = Selected()
	@State private var showSettingsSheet = false
	private var counter: Counter? {
		counters.first { $0.date == selected.date }
	}
	private var decreaseDisabled: Bool {
		counter == nil || counter?.count == 0
	}
	private var increaseDisabled: Bool {
		counter == nil
	}

	// MARK: - Layouts

	var body: some View {
		ZStack {
			Text(counter?.count.description ?? "0")
				.font(.system(size: 1000))
				.minimumScaleFactor(0.001)
				.lineLimit(1)
				.opacity(0.25)
				.padding()
				.contentTransition(.numericText())
				.accessibilityIdentifier("CountText")

			HStack {
				Button {
					withAnimation {
						counter?.decrease()
						sensory.trigger(.decrease)
					}
				} label: {
					Text("Minus")
						.frame(maxWidth: .infinity)
				}
				.disabled(decreaseDisabled)
				.accessibilityIdentifier("MinusButton")

				Button {
					withAnimation {
						counter?.increase()
						sensory.trigger(.increase)
					}
				} label: {
					Text("Plus")
						.frame(maxWidth: .infinity)
				}
				.disabled(increaseDisabled)
				.accessibilityIdentifier("PlusButton")
			}
			.frame(maxHeight: .infinity)
			.font(.system(size: 140.0))
		}
		.ignoresSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(counter?.date?.toRelative ?? "")
				.font(.system(size: 8))
				.padding(.trailing)
				.accessibilityIdentifier("DateText")
		}
		.overlay(alignment: .bottom) {
			Button("Settings") {
				showSettingsSheet = true
			}
			.padding(.bottom)
			.accessibilityIdentifier("SettingsButton")
		}
		.sheet(isPresented: $showSettingsSheet) {
			SettingsView(selected: selected)
		}
		.fontWeight(.bold)
		.monospaced()
		.tint(.accent)
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .active:
				do {
					try Counter.fetch(date: selected.date)
				} catch {
					alert.error = .fetch
					alert.show = true
					sensory.trigger(.error)
				}
			case .background:
				WidgetCenter.shared.reloadAllTimelines()
			default: break
			}
		}
	}
}

#Preview {
	ContentView()
		.environment(Alert())
		.environment(Sensory())
		.modelContainer(for: Counter.self,
						inMemory: true)
}
