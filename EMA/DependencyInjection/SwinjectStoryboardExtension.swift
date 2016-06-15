//
//  SwinjectExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 24/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Swinject

extension SwinjectStoryboard {
  class func setup() {

    // MARK: - Lost Object -

    defaultContainer.register(LostObjectAPI.self) { _ in LostObjectNetwork() }
  
    defaultContainer.register(LostObjectViewModel.self) { r in
      let viewModel = LostObjectViewModel(service: r.resolve(LostObjectAPI.self)!)
      return viewModel
    }
    
    defaultContainer.registerForStoryboard(LostObjectViewController.self) { r, c in
      c.viewModel = r.resolve(LostObjectViewModel.self)!
    }
    
    // MARK: - Login -
    
    defaultContainer.register(LoginAPI.self) { _ in LoginNetwork() }
   
    defaultContainer.register(LoginViewModel.self) { r in
      let viewModel = LoginViewModel(service: r.resolve(LoginAPI.self)!)
      return viewModel
    }
    
    defaultContainer.registerForStoryboard(LoginViewController.self) { r, c in
      c.viewModel = r.resolve(LoginViewModel.self)!
    }

    // MARK: - Profile -
    
    defaultContainer.register(ProfileAPI.self) { _ in ProfileNetwork() }
    
    defaultContainer.register(ProfileViewModel.self) { r in
      let viewModel = ProfileViewModel(service : r.resolve(ProfileAPI.self)!)
      return viewModel
    }
    
    defaultContainer.registerForStoryboard(ProfileViewController.self) { r, c in
      c.viewModel = r.resolve(ProfileViewModel.self)!
    }
    
    // MARK: - Event -
    
    defaultContainer.register(EventAPI.self) { _ in EventNetwork() }
    
    defaultContainer.register(EventViewModel.self) { r in
      let viewModel = EventViewModel(service: r.resolve(EventAPI.self)!)
      return viewModel
    }
    
    defaultContainer.registerForStoryboard(EventViewController.self) { r, c in
      c.viewModel = r.resolve(EventViewModel.self)!
    }
    
    // MARK: - Advertisement -
    
    defaultContainer.register(AdvertismentAPI.self) { _ in AdvertismentNetwork() }
    
    defaultContainer.register(AdvertismentViewModel.self) { r in
      let viewModel = AdvertismentViewModel(service: r.resolve(AdvertismentAPI.self)!)
      return viewModel
    }
    
    defaultContainer.registerForStoryboard(AdvertismentViewController.self) { r, c in
      c.viewModel = r.resolve(AdvertismentViewModel.self)!
    }
    
    // MARK: - Car Pooling -
    
    defaultContainer.register(CarPoolingAPI.self) { _ in CarPoolingNetwork() }
    
    defaultContainer.register(CarPoolingViewModel.self) { r in
      let viewModel = CarPoolingViewModel(service: r.resolve(CarPoolingAPI.self)!)
      return viewModel
    }
    
    defaultContainer.registerForStoryboard(CarPoolingViewController.self) { r, c in
      c.viewModel = r.resolve(CarPoolingViewModel.self)!
    }

  }
}