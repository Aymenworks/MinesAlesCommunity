//
//  CrudItem.swift
//  EMA
//
//  Created by Rebouh Aymen on 11/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

// For having generic UPDATE and Delete DELETE on the ProfileNetwork that manages the Update/Delete

protocol CrudItem {
  var api: String { get }
  var idItem: Int { get }
  var updateParameters: [String: AnyObject] { get }
}