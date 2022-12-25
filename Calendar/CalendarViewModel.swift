//
//  CalendarViewModel.swift
//  Calendar
//
//  Created by J_Min on 2022/12/25.
//

import UIKit
import Combine

final class CalendarViewModel {
    var component = [CalendarDateComponents]()
    let calendarManager = CalendarManager()
    
    private var subscriptions = Set<AnyCancellable>()
    
    let updateCollectionViewPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        binding()
    }
    
    func binding() {
        calendarManager.updateDatePublisher
            .map {
                print($0.date)
                return $0
            }
            .collect(calendarManager.dateCount())
            .sink { [weak self] dates in
                self?.component = dates
                self?.updateCollectionViewPublisher.send()
            }.store(in: &subscriptions)
    }
}
