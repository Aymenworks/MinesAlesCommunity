//
//  ProfileViewModel.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit



struct ProfileViewModel {
  
  // MARK: - Properties -
  
  let service: ProfileAPI
  let allItemsTitles = ["Events", "Covoiturage", "Annonces", "Objets perdus"]
  
  var lostObjectsCreated = [LostObject]() {
    didSet {
      lostObjectsCreated.sortInPlace { a, b in a.createdDate.toDate() >= b.createdDate.toDate() }
    }
  }
  
  var eventsCreated = [Event]() {
    didSet {
      eventsCreated.sortInPlace { a, b in a.startDate.toDate() >= b.startDate.toDate() }
    }
  }
  
  var advertismentsCreated = [Advertisment]() {
    didSet {
      advertismentsCreated.sortInPlace { a, b in a.createdDate.toDate() >= b.createdDate.toDate() }
    }
  }
  
  var carsPoolingCreated = [CarPooling]() {
    didSet {
      carsPoolingCreated.sortInPlace { a, b in a.startDate.toDate() >= b.startDate.toDate() }
    }
  }

  
  // MARK: - Lifecycle -
  
  init(service: ProfileAPI) {
    self.service = service
  }
  
  // MARK: - Data Setup -
  
  func numberOfElementAtIndex(index: Int) -> Int {
    switch index {
    case 0: return eventsCreated.count
    case 1: return carsPoolingCreated.count
    case 2: return advertismentsCreated.count
    case 3: return lostObjectsCreated.count
    default: return 0
    }
  }
  
  func foundTextForBoolean(found: Bool) -> String {
    return found ? "Trouvé" : "Perdu"
  }
  
  func categoryTextForCategoryIndex(index: Int) -> String {
    switch index {
    case 0: return "Soirée"
    case 1: return "Sortie"
    case 2: return "Sport"
    default: return "Divers"
    }
  }
  
  func attributeTextForNavigationFilterAtIndex(index: Int, textColor: UIColor = UIColor.lightGrayColor()) -> NSMutableAttributedString {
    let title = allItemsTitles[index]
    let numberOfElements = numberOfElementAtIndex(index)
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
  
  // MARK: - Network -
  
  func delete(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) {
    self.service.requestDelete(item) { response, error in
      completionBlock(response, error: error)
    }
  }
  
  func update(item: CrudItem,  completionBlock: SuccessResponseCompletionBlock) {
    self.service.requestUpdate(item) { response, error in
      completionBlock(response, error: error)
    }
  }
  
  func fetchAllMyCreatedItems(userId userId: Int, completionBlock: (response: ProfileResponse?, error: NSError?) -> ()) {
    self.service.requestAllCreatedItems(userId) { response, error in
      completionBlock(response: response, error: error)
    }
  }
}
