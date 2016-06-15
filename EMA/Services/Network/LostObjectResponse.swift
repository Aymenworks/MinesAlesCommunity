//
//  LostObjectResponse.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct AddResponse: Decodable {
  let id: Int
  
  static func decode(json: JSON) -> Decoded<AddResponse> {
    return curry(AddResponse.init)
      <^> (json <| "id" >>- toInt)
  }
}

struct SuccessResponse: Decodable {
  let success: Bool
  
  static func decode(json: JSON) -> Decoded<SuccessResponse> {
    return curry(SuccessResponse.init)
      <^> json <| "success"
  }
}

struct LostObjectResponse: Decodable {
  let lostObjects: [LostObject]
  
  static func decode(json: JSON) -> Decoded<LostObjectResponse> {
    return curry(LostObjectResponse.init)
      <^> json <|| "lostItems"
  }
}
