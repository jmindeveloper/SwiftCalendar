//
//  CalendarManager.swift
//  Calendar
//
//  Created by J_Min on 2022/12/24.
//

import Foundation
import Combine
import UIKit

enum WeekDay: Int {
    case sun = 0, mon, tue, wed, thu, fri, sat
    
    var weekday: String {
        switch self {
        case .sun:
            return "일요일"
        case .mon:
            return "월요일"
        case .tue:
            return "화요일"
        case .wed:
            return "수요일"
        case .thu:
            return "목요일"
        case .fri:
            return "금요일"
        case .sat:
            return "토요일"
        }
    }
}


struct CalendarDateComponents {
    let year: String
    let month: String
    let day: String
    let week: Int
    var dayColor: UIColor?
    var cellColor: UIColor? = .clear
    var isCurrentMonth: Bool
    
    var weekday: String {
        WeekDay(rawValue: week)?.weekday ?? "월요일"
    }
    
    var date: String {
        String.getDate(components: self)
    }
}

final class CalendarManager {
    
    private let calendar = Calendar.current
    private var calendarDate = Date()
    private var selectedCalendarDate = Date()
    
    private var minusCalendarMonth = Date()
    private var plusCalendarMonth = Date()
    
    let updateDatePublisher = PassthroughSubject<[CalendarDateComponents], Never>()
    
    init() {
        
    }
    
    func updateCalendar() {
        let date = calendar.component(.day, from: calendarDate) - 1
        calendarDate = calendar.date(byAdding: DateComponents(day: -date), to: calendarDate) ?? Date()
    }
    
    private func startDateOfMonth(from date: Date) -> Int {
        return calendar.component(.weekday, from: date) - 1
    }
    
    private func monthRange(from date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    private func createCalendarCellComponents(color: UIColor, date: Date, isCurrentMonth: Bool) -> CalendarDateComponents {
        let date = calendar.dateComponents([.year, .month, .day, .weekday], from: calendarDate)
                          
        let components = CalendarDateComponents(
            year: String(date.year ?? 2022),
            month: String(date.month ?? 1),
            day: String(date.day ?? 1),
            week: (date.weekday ?? 1) - 1,
            dayColor: color,
            isCurrentMonth: isCurrentMonth
        )
        
        return components
    }
    
    func dateCount() -> Int {
        let startDateOfTheWeek = startDateOfMonth(from: calendarDate)
        let currentEndDate = monthRange(from: calendarDate)
        
        return startDateOfTheWeek + currentEndDate
    }
    
    func updateDate() {
        let startDateOfTheWeek = startDateOfMonth(from: calendarDate)
        let currentEndDate = monthRange(from: calendarDate)
        calendarDate = calendar.date(byAdding: DateComponents(day: -startDateOfTheWeek), to: calendarDate) ?? Date()
        
        var components = [CalendarDateComponents]()
        for _ in 0..<currentEndDate + startDateOfTheWeek {
            components.append(createCalendarCellComponents(color: .darkGray, date: calendarDate, isCurrentMonth: true))
            calendarDate = calendar.date(byAdding: DateComponents(day: 1), to: calendarDate) ?? Date()
        }
        updateDatePublisher.send(components)
    }
    
    func plusMonth() {
        calendarDate = calendar.date(byAdding: DateComponents(month: 1), to: plusCalendarMonth) ?? Date()
        plusCalendarMonth = calendarDate
        
        updateCalendar()
        updateDate()
    }
    
    func minusMonth() {
        calendarDate = calendar.date(byAdding: DateComponents(month: -1), to: minusCalendarMonth) ?? Date()
        minusCalendarMonth = calendarDate
        
        updateCalendar()
        updateDate()
    }
}

extension String {
    static func getDate(components: CalendarDateComponents) -> String {
        return "\(components.year)년 \(components.month)월 \(components.day)일 \(components.weekday)"
    }
}
