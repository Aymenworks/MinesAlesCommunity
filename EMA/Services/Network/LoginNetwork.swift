//
//  LoginNetwork.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Curry

struct LoginNetwork: LoginAPI {
  func requestLoginWithLogin(login: String, password: String, completionBlock: (LoginResponse?, NSError?) -> ()) {
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/login", parameters: ["login": login, "password": password])
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<LoginResponse> = decode(json), let loginResponse = decoded.value {
          completionBlock(loginResponse, nil)
        } else {
          completionBlock(nil, response.result.error)
        }
    }
  }
}