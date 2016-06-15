//
//  UIAlertControllerExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 10/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit

extension UIAlertController {
  @nonobjc static let genericNetworkErrorAlertController: UIAlertController = {
    let alertController = UIAlertController(title: "Oops 😅", message: "Un problème est survenu. Veuillez reesayer plus târd. En attendant, vérifiez votre connexion internet.", preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    return alertController
  }()
}