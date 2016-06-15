//
//  LostObject.swift
//  EMA
//
//  Created by Rebouh Aymen on 24/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct LostObject {
  let id: Int
  var title: String
  var description: String
  var location: String?
  var found: Bool
  let creatorFirstName: String?
  let creatorLastName: String?
  
  var creatorName: String {
    return "\(creatorFirstName ?? "") \(creatorLastName ?? "")"
  }
  
  let creatorPhoneNumber: String?
  let creatorLogin: String?
  let createdDate: String
}

// MARK: - Network Mapping -

extension LostObject: Decodable {
  static func decode(json: JSON) -> Decoded<LostObject> {
    return curry(LostObject.init)
      <^> (json <| "id" >>- toInt)
      <*> json <| "title"
      <*> json <| "description"
      <*> json <|? "location"
      <*> (json <| "found" >>- toBoolean)
      <*> json <|? "firstname"
      <*> json <|? "lastname"
      <*> json <|? "phone"
      <*> json <|? "login"
      <*> json <| "created_date"
  }
}

let toBoolean: String -> Decoded<Bool> = {
  .fromOptional($0 == "1")
}

// MARK: - CrudItem Protocol -

extension LostObject: CrudItem {
  var api: String {
    return "lostItem"
  }
  
  var idItem: Int {
    return id
  }
  
  var updateParameters: [String: AnyObject] {
    return ["title": title, "description": description, "found": found, "location": location ?? ""]
  }
}