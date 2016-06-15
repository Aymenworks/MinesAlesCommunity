//
//  LostObjectViewModel.swift
//  EMA
//
//  Created by Rebouh Aymen on 24/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct LostObjectViewModel {
  
  // MARK: - Properties -
  
  let service: LostObjectAPI
  
  var lostObjects = [LostObject]() {
    didSet {
      updateCurrentObjects()
    }
  }
  
  var currentLostObjects = [LostObject]()
  
  var searchFilter = "" {
    didSet {
      updateCurrentObjects()
    }
  }
  
  var filterObjectFound = true {
    didSet {
      updateCurrentObjects()
    }
  }
  
  private struct StatusLostObjectImage {
    static let today  = UIImage(named: "circlePurple")!
    static let before = UIImage(named: "circleGrey")!
  }
  
  // MARK: - Lifecycle -
  
  init(service: LostObjectAPI) {
    self.service = service
  }
  
  // MARK: - Data format -
  
  mutating func updateCurrentObjects() {
    currentLostObjects = lostObjects.filter { filterObjectFound ? $0.found : !$0.found }
    
    if !searchFilter.isEmpty {
      currentLostObjects = currentLostObjects.filter { $0.title.lowercaseString.containsString(searchFilter.lowercaseString) || $0.description.lowercaseString.containsString(searchFilter.lowercaseString) || $0.description.lowercaseString.containsString(searchFilter.lowercaseString)
      || ($0.location ?? "").lowercaseString.containsString(searchFilter.lowercaseString)}
      
    }
    
    currentLostObjects.sortInPlace {
      a, b in a.createdDate.toDate() >= b.createdDate.toDate()
    }
  }
  
  func filterFormatted(text: String, size: CGFloat = 12) -> NSMutableAttributedString {
    return text.formatForCell(searchFilter, size: size)
  }
  
  func circleStatusForLostObject(lostObject: LostObject) -> UIImage {
    if lostObject.createdDate.isToday() {
      return StatusLostObjectImage.today
    } else {
      return StatusLostObjectImage.before
    }
  }
  
  func dateFormatForLostObject(lostObject: LostObject) -> String {
    if lostObject.createdDate.isToday() {
      return "Aujourd'hui"
    } else if lostObject.createdDate.isYesterday() {
      return "Hier"
    } else {
      return NSDateFormatter.dateFormatter.stringFromDate(lostObject.createdDate.toDate())
    }
  }
  
  // MARK: - Network -
  
  func fetchAllLostObjects(completionBlock: (response: LostObjectResponse?, error: NSError?) -> ())  {
    self.service.requestAllLostObjects { response, error in
      completionBlock(response: response, error: error)
    }
  }
  
  func addLostObject(title: String, description: String, found: Bool, creatorId: Int, location: String, createdDate: String, completionBlock: AddResponseCompletionBlock) {
    self.service.requestAddLostObject(title, description: description, found: found, creatorId: creatorId, location: location, createdDate: createdDate) { response, error in
      completionBlock(response, error: nil)
    }
  }
}