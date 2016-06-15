//
//  MFMailComposeViewControllerExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 03/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import MessageUI

extension MFMailComposeViewController {
  convenience init(subject: String, recipient: String, delegate: MFMailComposeViewControllerDelegate) {
    self.init()
    setSubject(subject)
    setToRecipients([recipient])
    self.mailComposeDelegate = delegate
  }
}

