//
//  Advertisement.swift
//  EMA
//
//  Created by Rebouh Aymen on 02/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

enum AdvertismentType: String, Decodable {
  case Sale = "Vente", Renting = "Location", Various = "Divers"
}

struct Advertisment {
  let id: Int
  var title: String
  var description: String
  var type: AdvertismentType
  var price: Float

  let createdDate: String

  let creatorFirstName: String?
  let creatorLastName: String?
  
  var creatorName: String {
    return "\(creatorFirstName) \(creatorLastName)"
  }
  
  let creatorPhoneNumber: String?
  let creatorLogin: String?
}

// MARK: - Network Mapping -

extension Advertisment: Decodable {
  static func decode(json: JSON) -> Decoded<Advertisment> {
    return curry(Advertisment.init)
      <^> (json <| "id" >>- toInt)
      <*> json <| "title"
      <*> json <| "description"
      <*> json <| "adv_type"
      <*> (json <| "price" >>- toFloat)
      <*> json <| "created_date"
      <*> json <|? "firstname"
      <*> json <|? "lastname"
      <*> json <|? "phone"
      <*> json <|? "login"
  }
}

let toFloat: String -> Decoded<Float> = {
  .fromOptional(Float($0))
}

// MARK: - CrudItem Protocol -

extension Advertisment: CrudItem {
  var api: String {
    return "advertisement"
  }
  
  var idItem: Int {
    return id
  }
  
  var updateParameters: [String: AnyObject] {
    return ["title": title, "description": description, "price": price, "adv_type": type.rawValue]
  }
}