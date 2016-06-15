//
//  NSDateFormatterExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 31/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

extension NSDateFormatter {
  @nonobjc static let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
  }()
  
  @nonobjc static let frenchDateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy à HH:mm"
    return dateFormatter
  }()
}