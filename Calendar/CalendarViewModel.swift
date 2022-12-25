//
//  CalendarViewModel.swift
//  Calendar
//
//  Created by J_Min on 2022/12/25.
//

import UIKit
import Combine

final class CalendarViewModel {
    var component = [[CalendarDateComponents]]()
    let calendarManager = CalendarManager()
    
    private var subscriptions = Set<AnyCancellable>()
    
    let updateCollectionViewPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        calendarManager.updateCalendar()
        binding()
        calendarManager.updateDate()
    }
    
    func binding() {
        calendarManager.updateDatePublisher
            .sink { [weak self] dates in
                self?.component.append(dates)
                self?.updateCollectionViewPublisher.send()
            }.store(in: &subscriptions)
    }
    
    func addPlushMonth() {
        calendarManager.plusMonth()
    }
    
    func addMinusMonth() {
        
    }
}
