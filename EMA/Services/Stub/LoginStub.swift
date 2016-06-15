//
//  LoginStub.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire

struct LoginStub: LoginAPI {
  func requestLoginWithLogin(login: String, password: String, completionBlock: (LoginResponse?, NSError?) -> ()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        if login == "aymen.rebouh" && password == "000000" {
          let profile = Student(id: 1, firstName: "Aymen", lastName: "Rebouh", login: "aymen.rebouh", phoneNumber: "0623185407")
          completionBlock(LoginResponse(success: true, token: "ofkzokdzoko", profile: profile), nil)
        } else {
          completionBlock(LoginResponse(success: false, token: nil, profile: nil), nil)
        }
      }
    }
  }
}