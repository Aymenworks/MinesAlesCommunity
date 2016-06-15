//
//  NSDateExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 31/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

public func >=(a: NSDate, b: NSDate) -> Bool {
  return a.compare(b) == NSComparisonResult.OrderedDescending || a.compare(b) == NSComparisonResult.OrderedSame
}