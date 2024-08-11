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
	private let settingsTip = SettingsTip()
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
					Button("Minus") {
						withAnimation {
							do {
								try selected.counter?.decrease()
								sensory.feedback(feedback: .decrease)
							} catch {
								alert.error = .decrease
								alert.show = true
								sensory.feedback(feedback: .error)
							}
						}
					}
					.frame(maxWidth: .infinity)
					.buttonRepeatBehavior(.enabled)
					.disabled(decreaseDisabled)
					.accessibilityIdentifier("MinusButton")

					Button("Plus") {
						withAnimation {
							do {
								try selected.counter?.increase()
								sensory.feedback(feedback: .increase)
							} catch {
								alert.error = .increase
								alert.show = true
								sensory.feedback(feedback: .error)
							}
						}
					}
					.frame(maxWidth: .infinity)
					.buttonRepeatBehavior(.enabled)
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
					settingsTip.invalidate(reason: .actionPerformed)
				}
				.padding(.bottom)
				.popoverTip(settingsTip,
							arrowEdge: .top)
				.onAppear {
					Task {
						try await Task.sleep(for: .seconds(1))
						SettingsTip.show = true
					}
				}
				.accessibilityIdentifier("SettingsButton")
			}
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
				Task {
					do {
						selected.counter = try await Counter.fetch(date: selected.date)
					} catch {
						alert.error = .fetch
						alert.show = true
						sensory.feedback(feedback: .error)
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
		.modelContainer(for: [Counter.self],
						inMemory: true)
}
