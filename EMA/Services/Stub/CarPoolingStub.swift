//
//  CarPoolingStub.swift
//  EMA
//
//  Created by Rebouh Aymen on 12/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

struct CarPoolingStub: CarPoolingAPI {
  
  func requestAllCarsPooling(completionBlock: (CarPoolingResponse?, NSError?) -> ()) {
    let response = CarPoolingResponse(carsPooling: [
      CarPooling(id: 1, startArrival: "Marseille", endArrival: "Paris", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 38, seatAvailable: 4, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
       CarPooling(id: 2, startArrival: "Paris", endArrival: "Lille", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 10.5, seatAvailable: 2, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
       CarPooling(id: 3, startArrival: "Nice", endArrival: "Bordeaux", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 22, seatAvailable: 3, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
       CarPooling(id: 4, startArrival: "Lyon", endArrival: "Nîmes", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 17, seatAvailable: 1, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
       CarPooling(id: 5, startArrival: "Lyon", endArrival: "Genève", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 15, seatAvailable: 2, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
       CarPooling(id: 6, startArrival: "Alès", endArrival: "Nîmes", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 4, seatAvailable: 4, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh")
      ])
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(response, nil)
      }
    }
  }
  
  func requestAddCarPooling(startLocation: String, endLocation: String, startDate: String, createdDate: String, price: Float, numberOfSeats: Int, description: String, creatorId: Int, completionBlock: AddResponseCompletionBlock) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(AddResponse(id: 11+(Int(arc4random())%2000)), error: nil)
      }
    }
  }
}
