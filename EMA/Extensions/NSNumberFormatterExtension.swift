//
//  NSNumberFormatter.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
  @nonobjc static let numberFormatter: NSNumberFormatter = {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.usesSignificantDigits = true
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
    return numberFormatter
  }()
}