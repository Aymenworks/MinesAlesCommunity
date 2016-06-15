//
//  CarPoolingAPI.swift
//  EMA
//
//  Created by Rebouh Aymen on 12/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

protocol CarPoolingAPI {
  func requestAllCarsPooling(completionBlock: (CarPoolingResponse?, NSError?) -> ())
  func requestAddCarPooling(startLocation: String, endLocation: String, startDate: String, createdDate: String, price: Float, numberOfSeats: Int, description: String, creatorId: Int, completionBlock:  AddResponseCompletionBlock)
}
