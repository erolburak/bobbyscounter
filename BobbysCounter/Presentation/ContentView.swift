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

	@Environment(\.modelContext) private var modelContext
	@Environment(\.scenePhase) private var scenePhase
	@Environment(Alert.self) private var alert
	@Environment(Sensory.self) private var sensory
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var selected = Selected()
	@State private var showSettingsSheet = false
	private var count: Int? {
		selected.counter?.count
	}
	private var decreaseDisabled: Bool {
		count == nil || count == 0
	}
	private var isCountNil: Bool {
		count == nil
	}

	// MARK: - Layouts

	var body: some View {
		ZStack {
			if isCountNil {
				Text("EmptyCount")
			} else if let count {
				Text(count.description)
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
							selected.counter?.decrease()
							sensory.feedbackTrigger(feedback: .decrease)
						}
					} label: {
						Text("Minus")
							.frame(maxWidth: .infinity)
					}
					.disabled(decreaseDisabled)
					.accessibilityIdentifier("MinusButton")

					Button {
						withAnimation {
							selected.counter?.increase()
							sensory.feedbackTrigger(feedback: .increase)
						}
					} label: {
						Text("Plus")
							.frame(maxWidth: .infinity)
					}
					.accessibilityIdentifier("PlusButton")
				}
				.frame(maxHeight: .infinity)
				.font(.system(size: 140.0))
			}
		}
		.ignoresSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			if !isCountNil {
				Text(selected.counter?.date?.toRelative ?? "")
					.font(.system(size: 8))
					.padding(.trailing)
					.accessibilityIdentifier("DateText")
			}
		}
		.overlay(alignment: .bottom) {
			if !isCountNil {
				Button("Settings") {
					showSettingsSheet = true
				}
				.padding(.bottom)
				.accessibilityIdentifier("SettingsButton")
			}
		}
		.sheet(isPresented: $showSettingsSheet) {
			SettingsView(selected: selected)
		}
		.fontWeight(.bold)
		.monospaced()
		.tint(.accent)
		.onAppear {
			CounterActor.createSharedInstance(modelContext: modelContext)
		}
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .active:
				Task {
					do {
						selected.counter = try await CounterActor.shared.fetch(date: selected.date)
					} catch {
						alert.error = .fetch
						alert.show = true
						sensory.feedbackTrigger(feedback: .error)
					}
				}
			case .background:
				WidgetCenter.shared.reloadAllTimelines()
			default:
				break
			}
		}
	}
}

#Preview {
	ContentView()
		.environment(Alert())
		.environment(Sensory())
		.modelContainer(inMemory: true)
}
