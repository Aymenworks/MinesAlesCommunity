//
//  NSUserDefaultExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

extension NSUserDefaults {
  func saveProfile(profile: Student) {
    setInteger(profile.id, forKey: "id")
    setObject(profile.login, forKey: "login")
    setObject(profile.phoneNumber, forKey: "phoneNumber")
    setObject(profile.firstName, forKey: "firstName")
    setObject(profile.lastName, forKey: "lastName")
  }
  
  var phoneNumber: String? {
    return objectForKey("phoneNumber") as? String
  }

  var login: String {
    return objectForKey("login") as! String
  }
  
  var id: Int {
    return integerForKey("id")
  }
  
  var token: String {
    return objectForKey("token") as! String
  }

  
  var firstName: String {
    return objectForKey("firstName") as! String
  }
  
  var lastName: String {
    return objectForKey("firstName") as! String
  }
  
  var fullName: String {
    return "\(objectForKey("firstName") as! String) \(objectForKey("firstName") as! String)"
  }
  
}