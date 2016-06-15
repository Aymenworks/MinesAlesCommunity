//
//  LoginAPI.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

protocol LoginAPI {
  func requestLoginWithLogin(login: String, password: String, completionBlock: (LoginResponse?, NSError?) -> ())
}