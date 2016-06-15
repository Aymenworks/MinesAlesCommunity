//
//  UIColorExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit

extension UIColor {
  
  private static let filterTextButtonGreyUIColor = UIColor(red: 240/255, green: 240/255, blue: 241/255, alpha: 1.0)
  private static let mainGreyUIColor = UIColor(red: 246/255, green: 246/255, blue: 247/255, alpha: 1.0)
  private static let minesAlesUIColor = UIColor(red: 171/255, green: 39/255, blue: 73/255, alpha: 1.0)
  private static let detailRightCellGreyUIColor = UIColor(red: 189/255, green: 202/255, blue: 219/255, alpha: 1.0)
  
  class func minesAlesColor() -> UIColor {
    return minesAlesUIColor
  }
  
  class func filterTextButtonGreyColor() -> UIColor {
    return filterTextButtonGreyUIColor
  }
  
  class func mainGreyColor() -> UIColor {
    return mainGreyUIColor
  }
  
  class func detailRightCellGreyColor() -> UIColor {
    return detailRightCellGreyUIColor
  }
}
