//
//  FilterButton.swift
//  EMA
//
//  Created by Rebouh Aymen on 02/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit

class FilterButton: UIButton {
  
  override
  var selected: Bool {
    didSet {
      if selected {
        backgroundColor = UIColor.minesAlesColor()
      } else {
        backgroundColor = UIColor.clearColor()
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    layer.cornerRadius = 1.5
    titleLabel!.textAlignment = .Center
  }

}
