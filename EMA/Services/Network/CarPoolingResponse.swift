//
//  CarPoolingResponse.swift
//  EMA
//
//  Created by Rebouh Aymen on 12/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct CarPoolingResponse: Decodable {
  let carsPooling: [CarPooling]

  
  static func decode(json: JSON) -> Decoded<CarPoolingResponse> {
    return curry(CarPoolingResponse.init)
      <^> json <|| "carpools"
  }
}
