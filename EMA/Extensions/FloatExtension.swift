//
//  FloatExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

extension Float {
  func formatPrice() -> NSMutableAttributedString {
    var priceString = NSNumberFormatter.numberFormatter.stringFromNumber(NSNumber(float: self))!
    priceString += "€"
    
    let attributedString = NSMutableAttributedString(string: priceString)
    
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.minesAlesColor(),
                                  range: (priceString as NSString).rangeOfString("\(self)", options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.detailRightCellGreyColor(),
                                  range: (priceString as NSString).rangeOfString("€", options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(43),
                                  range: (priceString as NSString).rangeOfString(priceString, options: NSStringCompareOptions.CaseInsensitiveSearch))
    
    return attributedString
  }

}