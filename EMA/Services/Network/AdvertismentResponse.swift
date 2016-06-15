//
//  AdvertisementResponse.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct AdvertismentResponse: Decodable {
  let advertisements: [Advertisment]
  
  static func decode(json: JSON) -> Decoded<AdvertismentResponse> {
    return curry(AdvertismentResponse.init)
      <^> json <|| "advertisements"
  }
}
