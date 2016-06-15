//
//  LoginResponse.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct LoginResponse: Decodable {
  let success: Bool
  let token: String?
  let profile: Student?

  static func decode(json: JSON) -> Decoded<LoginResponse> {
    return curry(LoginResponse.init)
      <^> json <| "success"
      <*> json <|? "token"
      <*> json <|? "profile"
  }
}
