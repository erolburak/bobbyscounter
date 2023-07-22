//
//  SettingsView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

struct SettingsView: View {

	// MARK: - Properties

	@Binding var counter: Counter?
	@Binding var selectedDate: Date
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \.date, order: .forward) private var counters: [Counter]
	@State var viewModel: SettingsViewModel

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			VStack {
				DatePicker("SelectedDate",
						   selection: $selectedDate,
						   in: ...Date(),
						   displayedComponents: [.date])
				.datePickerStyle(.compact)
				.padding()

				Spacer()
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Reset") {
						viewModel.showConfirmationDialog.toggle()
					}
					.disabled(counters.isEmpty)
				}

				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
					}
				}

				ToolbarItem(placement: .bottomBar) {
					Button("Today") {
						selectedDate = .now
					}
					.disabled(selectedDate.isDateToday)
				}
			}
			.confirmationDialog("ConfirmationDialogTitle",
								isPresented: $viewModel.showConfirmationDialog,
								titleVisibility: .visible) {
				Button("Reset",
					   role: .destructive) {
					selectedDate = .now
					Task {
						counter = try await viewModel.reset(selectedDate: selectedDate)
					}
					dismiss()
				}
			}
			.alert(isPresented: $viewModel.showAlert,
				   error: viewModel.alertError) { _ in
			} message: { error in
				if let message = error.recoverySuggestion {
					Text(message)
				}
			}
			.onChange(of: selectedDate) {
				Task {
					counter = try await viewModel.setCounter(counters: counters,
															 selectedDate: selectedDate)
				}
				dismiss()
			}
		}
		.presentationDetents([.fraction(0.3)])
		.tint(.red)
	}
}
