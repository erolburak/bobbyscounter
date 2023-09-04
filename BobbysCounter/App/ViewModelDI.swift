//
//  ViewModelDI.swift
//  BobbysCounter
//
//  Created by Burak Erol on 04.09.23.
//

struct ViewModelDI {

	// MARK: - Properties

	static let shared = ViewModelDI()

	// MARK: - Actions

	func contentViewModel() -> ContentViewModel {
		ContentViewModel(decreaseCounterCountUseCase: DecreaseCounterCountUseCase(),
						 fetchCounterUseCase: FetchCounterUseCase(),
						 increaseCounterCountUseCase: IncreaseCounterCountUseCase(),
						 insertCounterUseCase: InsertCounterUseCase())
	}

	func settingsViewModel(counterSelected: CounterSelected) -> SettingsViewModel {
		SettingsViewModel(counterSelected: counterSelected,
						  fetchCounterUseCase: FetchCounterUseCase(),
						  insertCounterUseCase: InsertCounterUseCase(),
						  resetCountersUseCase: ResetCountersUseCase())
	}
}
