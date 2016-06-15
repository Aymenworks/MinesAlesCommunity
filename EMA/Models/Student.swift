//
//  Student.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Argo
import Curry

struct Student {
  var id: Int
  let firstName: String
  let lastName: String
  let login: String
  let phoneNumber: String?
}

// MARK: - Network Mapping -

extension Student: Decodable {
  static func decode(json: JSON) -> Decoded<Student> {
    return curry(Student.init)
      <^> (json <| "id" >>- toInt)
      <*> json <| "firstname"
      <*> json <| "lastname"
      <*> json <| "login"
      <*> json <|? "phone"
  }
}

let toInt: String -> Decoded<Int> = {
  .fromOptional(Int($0))
}