//
//  EventViewModel.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import RxDataSources

struct EventViewModel {
  
  // MARK: - Properties -
  
  let service: EventAPI
  
  let allItemsTitles = ["Soirées", "Sorties", "Sports", "Divers"]

  var events = [Event]() {
    didSet {
      updateCurrentEvents()
    }
  }
  
  var filteredEvents = [Event]()
  
  var searchFilter = "" {
    didSet {
      updateCurrentEvents()
    }
  }
  
  var filter = EventNavigationFilter.Party {
    didSet {
      updateCurrentEvents()
    }
  }
  
  // MARK: - Lifecycle -
  
  init(service: EventAPI) {
    self.service = service
  }
  
  // MARK: - Data format -
  
  mutating func updateCurrentEvents() {
    filteredEvents = events.filter { $0.type.hashValue == filter.rawValue }
    
    if !searchFilter.isEmpty {
      filteredEvents = filteredEvents.filter { $0.title.lowercaseString.containsString(searchFilter.lowercaseString) || $0.description.lowercaseString.containsString(searchFilter.lowercaseString) || ($0.location ?? "").lowercaseString.containsString(searchFilter.lowercaseString) }
    }
    
    filteredEvents.sortInPlace { a, b in a.startDate.toDate() >= b.startDate.toDate() }
  }
  
  func filterFormatted(text: String, size: CGFloat = 12) -> NSMutableAttributedString {
    return text.formatForCell(searchFilter, size: size)
  }
  
  func attributeTextForNavigationFilterAtIndex(index: Int, textColor: UIColor = UIColor.lightGrayColor()) -> NSMutableAttributedString {
    let title = allItemsTitles[index]
    let numberOfElements = events.filter { $0.type.hashValue == index }.count
    let text = "\(numberOfElements)\n\(title)"
    
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor,
                                  range: (text as NSString).rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12),
                                  range: (text as NSString).rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(15),
                                  range: (text as NSString).rangeOfString("\(numberOfElements)", options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    return attributedString
  }
  
  func dateFormatForEvent(event: Event) -> String {
    if event.startDate.isToday() {
      return "Aujourd'hui"
    } else {
      return NSDateFormatter.dateFormatter.stringFromDate(event.startDate.toDate())
    }
  }
  
  // MARK: - Network -
  
  func fetchAllEvents(completionBlock: (eventResponse : EventResponse?, error: NSError?) -> ())  {
    self.service.requestAllEvents { response, error in
      completionBlock(eventResponse: response, error: error)
    }
  }
  
  func addEventWith(title title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType, creatorId: Int, completionBlock:  AddResponseCompletionBlock) {
    self.service.requestAddEvent(title, location: location, startDate: startDate, endDate: endDate, createdDate: createdDate, description: description, type: type, creatorId: creatorId) { response, error in
      completionBlock(response, error: error)
    }
  }
}
