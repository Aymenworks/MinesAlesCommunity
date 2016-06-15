//
//  SpringViewExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import Spring

extension SpringView {
  func shake() {
    animation = "shake"
    duration = 1.0
    animate()
  }
}