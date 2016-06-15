//
//  CarPooling.swift
//  EMA
//
//  Created by Rebouh Aymen on 12/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct CarPooling {
  let id: Int
  var startArrival: String
  var endArrival: String
  var startDate: String
  var createdDate: String
  var description: String
  var price: Float
  var seatAvailable: Int
  let creatorFirstName: String?
  let creatorLastName: String?
  let creatorPhoneNumber: String?
  let creatorLogin: String?
  
  var creatorName: String {
    return "\(creatorFirstName ?? "") \(creatorLastName ?? "")"
  }
}

// MARK: - Network Mapping -

extension CarPooling: Decodable {
  static func decode(json: JSON) -> Decoded<CarPooling> {
    let decoded = curry(CarPooling.init)
      <^> (json <| "id" >>- toInt)
      <*> json <| "start"
      <*> json <| "arrival"
      <*> json <| "start_date"
      <*> json <| "created_date"
    
    return decoded
      <*> json <| "description"
      <*> (json <| "price" >>- toFloat)
      <*> (json <| "seat_available" >>- toInt)
      <*> json <|? "firstname"
      <*> json <|? "lastname"
      <*> json <|? "phone"
      <*> json <|? "login"
  }
}

// MARK: - CrudItem Protocol -

extension CarPooling: CrudItem {
  var api: String {
    return "carpool"
  }
  
  var idItem: Int {
    return id
  }
  
  var updateParameters: [String : AnyObject]  {
    return ["start": startArrival, "arrival": endArrival, "start_date": startDate, "description": description, "price": price, "seat_available": seatAvailable, "id_user": NSUserDefaults.standardUserDefaults().id, "token": NSUserDefaults.standardUserDefaults().token]
  }
}