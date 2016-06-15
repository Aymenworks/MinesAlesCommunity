//
//  ProfileResponse.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct ProfileResponse: Decodable {
  let lostObjects: [LostObject]
  let events: [Event]
  let advertisments: [Advertisment]
  let carsPooling: [CarPooling]
  
  static func decode(json: JSON) -> Decoded<ProfileResponse> {
    return curry(ProfileResponse.init)
      <^> json <|| "lostItems"
      <*> json <|| "events"
      <*> json <|| "advertisements"
      <*> json <|| "carpools"
  }
}
