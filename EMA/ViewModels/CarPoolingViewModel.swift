//
//  CarPoolingViewModel.swift
//  EMA
//
//  Created by Rebouh Aymen on 12/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

struct CarPoolingViewModel {
  
  // MARK: - Properties -
  
  let service: CarPoolingAPI
  
  var carsPooling = [CarPooling]() {
    didSet {
      updateCurrentCarsPooling()
    }
  }
  
  var currentCarsPooling = [CarPooling]()
  
  var searchFilter = "" {
    didSet {
      updateCurrentCarsPooling()
    }
  }
  
  var filterStartLocation = true {
    didSet {
      updateCurrentCarsPooling()
    }
  }
  
  // MARK: - Lifecycle -
  
  init(service: CarPoolingAPI) {
    self.service = service
  }
  
  // MARK: - Data format -
  
  mutating func updateCurrentCarsPooling() {
    currentCarsPooling = carsPooling

    if !searchFilter.isEmpty {
      if filterStartLocation {
        currentCarsPooling = currentCarsPooling.filter { $0.startArrival.lowercaseString.containsString(searchFilter.lowercaseString) }
      } else {
        currentCarsPooling = currentCarsPooling.filter { $0.endArrival.lowercaseString.containsString(searchFilter.lowercaseString) }
      }
    }
    
    currentCarsPooling.sortInPlace {
      a, b in a.startDate.toDate() >= b.startDate.toDate()
    }
  }
  
  func formatPrice(price: Float) -> String {
    return "\(price)€/place"
  }
  
  func formatNumberOfSeats(numberOfSeats: Int) -> NSMutableAttributedString {
    let text = "\(numberOfSeats)\n places restantes"
    
    let attributedString = NSMutableAttributedString(string: text)
    
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.minesAlesColor(),
                                  range: (text as NSString).rangeOfString("\(numberOfSeats)", options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.detailRightCellGreyColor(),
                                  range: (text as NSString).rangeOfString("places restantes", options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11),
                                  range: (text as NSString).rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch))

    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(43),
                                  range: (text as NSString).rangeOfString("\(numberOfSeats)", options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    return attributedString
  }

  
  func filterFormatted(text: String, size: CGFloat = 15) -> NSMutableAttributedString {
    return text.formatForCell(searchFilter, size: size)
  }
  
  func dateFormat(date: String) -> String {
    if date.isToday() {
      return "Aujourd'hui"
    } else if date.isYesterday() {
      return "Hier"
    } else {
      return NSDateFormatter.dateFormatter.stringFromDate(date.toDate())
    }
  }
  
  // MARK: - Network -
  
  func fetchAllCarsPooling(completionBlock: (response: CarPoolingResponse?, error: NSError?) -> ())  {
    self.service.requestAllCarsPooling { response, error in
      completionBlock(response: response, error: error)
    }
  }
  
  func addCarPooling(startLocation: String, endLocation: String, startDate: String, createdDate: String, price: Float, numberOfSeats: Int, description: String, creatorId: Int, completionBlock: AddResponseCompletionBlock) {
    self.service.requestAddCarPooling(startLocation, endLocation: endLocation, startDate: startDate, createdDate: createdDate, price: price, numberOfSeats: numberOfSeats, description: description, creatorId: creatorId) { response, error in
      completionBlock(response, error: error)
    }
  }
  
}