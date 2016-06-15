//
//  StringExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 31/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit

extension String {
  func formatForCell(searchFilter: String, size: CGFloat) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: self)
    if searchFilter.isEmpty {
      return attributedString
    }
    
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(size),
                                  range: (self as NSString).rangeOfString(searchFilter, options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(),
                                  range: (self as NSString).rangeOfString(searchFilter, options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    return attributedString
  }
  
  func toMinesAlesEmail() -> String {
    return self + "@mines-ales.org"
  }
  
  func toCellFormatDate() -> String {
    if self.isToday() {
      return "Aujourd'hui"
    } else if self.isYesterday() {
      return "Hier"
    } else {
      return self
    }
  }
  
  
  func dateFormat() -> String {
    if self.isToday() {
      return "Aujourd'hui"
    } else if self.isYesterday() {
      return "Hier"
    } else {
      return NSDateFormatter.dateFormatter.stringFromDate(self.toDate())
    }
    
  }
  
  func toDate() -> NSDate {
    return NSDateFormatter.dateFormatter.dateFromString(self)!
  }
  
  func isToday() -> Bool {
    let todayComponent = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: NSDate())
    let dateComponent = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: self.toDate())
    
    return todayComponent.day == dateComponent.day && todayComponent.month == dateComponent.month
      && todayComponent.year == dateComponent.year
  }
  
  func isYesterday() -> Bool {
    var yesterdayComponent = NSDateComponents()
    yesterdayComponent.day = -1
    let yesterdayDate = NSCalendar.currentCalendar().dateByAddingComponents(yesterdayComponent, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)!
    yesterdayComponent = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: yesterdayDate)
    let dateComponent = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: self.toDate())
    
    return yesterdayComponent.day == dateComponent.day && yesterdayComponent.month == dateComponent.month
      && yesterdayComponent.year == dateComponent.year
  }
}