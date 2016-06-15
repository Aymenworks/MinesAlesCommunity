//
//  AdvertisementViewModel.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import RxDataSources

struct AdvertismentViewModel {
  
  // MARK: - Properties -
  
  let service: AdvertismentAPI
  
  let allItemsTitles = ["Ventes", "Location", "Divers"]

  var advertisements = [Advertisment]() {
    didSet {
      updateFilteredAdvertisements()
    }
  }
  
  var filteredAdvertisments = [Advertisment]()
  
  var searchFilter = "" {
    didSet {
      updateFilteredAdvertisements()
    }
  }
  
  var filter = AdvertismentNavigationFilter.Sale {
    didSet {
      updateFilteredAdvertisements()
    }
  }
  
  // MARK: - Lifecycle -
  
  init(service: AdvertismentAPI) {
    self.service = service
  }
  
  // MARK: - Data format -
  
  mutating func updateFilteredAdvertisements() {
    filteredAdvertisments = advertisements.filter { $0.type.hashValue == filter.rawValue }
    
    if !searchFilter.isEmpty {
      filteredAdvertisments = filteredAdvertisments.filter { $0.title.lowercaseString.containsString(searchFilter.lowercaseString) || $0.description.lowercaseString.containsString(searchFilter.lowercaseString)  }
    }
    
    filteredAdvertisments.sortInPlace { a, b in a.createdDate.toDate() >= b.createdDate.toDate() }
  }
  
  func filterFormatted(text: String, size: CGFloat = 12) -> NSMutableAttributedString {
    return text.formatForCell(searchFilter, size: size)
  }

  func attributeTextForNavigationFilterAtIndex(index: Int, textColor: UIColor = UIColor.lightGrayColor()) -> NSMutableAttributedString {
    let title = allItemsTitles[index]
    let numberOfElements = advertisements.filter { $0.type.hashValue == index }.count
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
  
  func fetchAllAdvertisements(completionBlock: (advertisementsResponse : AdvertismentResponse?, error: NSError?) -> ())  {
    self.service.requestAllAdvertisments { response, error in
      completionBlock(advertisementsResponse: response, error: error)
    }
  }
  
  func addAdvertisementWith(title title: String, description: String, price: Float, createdDate: String, type: AdvertismentType, creatorId: Int, completionBlock:  AddResponseCompletionBlock) {
    self.service.requestAddAdvertisment(title: title, description: description, price: price, createdDate: createdDate, type: type, creatorId: creatorId) { response, error in
      completionBlock(response, error: error)
    }
  }
}
