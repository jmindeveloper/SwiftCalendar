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
    
    private var isPlusMonth = true
    
    let updateCollectionViewPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        calendarManager.updateCalendar()
        binding()
        calendarManager.updateDate()
        addMinusMonth()
        addMinusMonth()
        addPlushMonth()
        addPlushMonth()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.updateCollectionViewPublisher.send()
        }
    }
    
    func binding() {
        calendarManager.updateDatePublisher
            .sink { [weak self] dates in
                if self?.isPlusMonth == true {
                    self?.component.append(dates)
                } else {
                    self?.component.insert(dates, at: 0)
                }
            }.store(in: &subscriptions)
    }
    
    func addPlushMonth() {
        isPlusMonth = true
        calendarManager.plusMonth()
//        updateCollectionViewPublisher.send()
    }
    
    func addMinusMonth() {
        isPlusMonth = false
        calendarManager.minusMonth()
//        updateCollectionViewPublisher.send()
    }
}
