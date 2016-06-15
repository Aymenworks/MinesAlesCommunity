//
//  EventResponse.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct EventResponse: Decodable {
  let events: [Event]
  
  static func decode(json: JSON) -> Decoded<EventResponse> {
    return curry(EventResponse.init)
      <^> json <|| "events"
  }
}
