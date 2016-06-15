//
//  ProfileViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import Argo
import Curry

enum ProfileNavigationFilter: Int {
  case Event, CarPooling, Advertisment, LostObject
}


class ProfileViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var eventFilterButton: FilterButton! {
    didSet {
      eventFilterButton.selected = true
    }
  }
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
    }
  }
  
  var categoryFilter = ProfileNavigationFilter.Event
  
  @IBOutlet weak var carPoolingFilterButton: FilterButton!
  @IBOutlet weak var advertismentFilterButton: FilterButton!
  @IBOutlet weak var lostObjectFilterButton: FilterButton!
  
  var viewModel: ProfileViewModel!
  let disposeBag = DisposeBag()
  
  let refreshControl = UIRefreshControl()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.addSubview(refreshControl)
    
    refreshControl
      .rx_controlEvent(.ValueChanged)
      .asDriver()
      .driveNext {
        self.fetchAllCreatedItems(byShowingLoader: false)
      }.addDisposableTo(disposeBag)
    
    bindView()
    fetchAllCreatedItems(byShowingLoader: true)
  }
  
  func fetchAllCreatedItems(byShowingLoader showLoader: Bool) {
    if showLoader {
      AWLoader.show()
    }
    viewModel.fetchAllMyCreatedItems(userId: NSUserDefaults.standardUserDefaults().id) { response, error in
      
      if self.refreshControl.refreshing {
        self.refreshControl.endRefreshing()
      }
      
      guard error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        self.displayOrUpdateNavigationFilterBar()
        AWLoader.hide()
        return
      }
      
      if let lostObjects = response?.lostObjects {
        self.viewModel.lostObjectsCreated = lostObjects
      }
      
      if let events = response?.events {
        self.viewModel.eventsCreated = events
      }
      
      if let advertisments = response?.advertisments {
        self.viewModel.advertismentsCreated = advertisments
      }
      
      if let carsPooling = response?.carsPooling {
        self.viewModel.carsPoolingCreated = carsPooling
      }
      
      self.displayOrUpdateNavigationFilterBar()
      
      self.tableView.reloadData()
      AWLoader.hide()
    }
    
  }
  
  // MARK: - User interface and interaction -
  
  func displayOrUpdateNavigationFilterBar() {
    for (index,button) in [self.eventFilterButton, self.carPoolingFilterButton, self.advertismentFilterButton, self.lostObjectFilterButton].enumerate() {
      button.setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(index), forState: .Normal)
      button.setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(index, textColor: UIColor.filterTextButtonGreyColor()), forState: .Selected)
    }
  }
  
  func bindView() {
    
    // When clicking on the cell
    tableView
      .rx_itemSelected
      .asDriver()
      .driveNext { indexPath in
        
        let optionController: UIAlertController
        let updateHandler: (UIAlertAction) -> ()
        let title: String
        let description: String
        
        if self.categoryFilter == ProfileNavigationFilter.LostObject {
          
          let lostObject = self.viewModel.lostObjectsCreated[indexPath.row]
          title = lostObject.title
          description = lostObject.description
          let cell       = self.tableView.cellForRowAtIndexPath(indexPath) as! EditableLostObjectTableViewCell
          cell.selected  = false
          
          updateHandler = { _ in
            let lostObjectController = self.storyboard!.instantiateViewControllerWithIdentifier("AddUpdateLostObjectViewController") as! AddUpdateLostObjectViewController
            lostObjectController.delegate = self
            lostObjectController.lostObject = lostObject
            self.presentViewController(lostObjectController, animated: true, completion: nil)
          }
          
        } else if self.categoryFilter == ProfileNavigationFilter.Advertisment {
          
          let advertisment = self.viewModel.advertismentsCreated[indexPath.row]
          title = advertisment.title
          description = advertisment.description
          let cell       = self.tableView.cellForRowAtIndexPath(indexPath) as! EditableAdvertismentTableViewCell
          cell.selected  = false
          
          updateHandler = { _ in
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddUpdateAdvertismentViewController") as! AddUpdateAdvertismentViewController
            controller.delegate = self
            controller.advertisment = advertisment
            self.presentViewController(controller, animated: true, completion: nil)
            
          }
          
        } else if self.categoryFilter == ProfileNavigationFilter.CarPooling {
          
          let carPooling = self.viewModel.carsPoolingCreated[indexPath.row]
          title = "\(carPooling.startArrival) --> \(carPooling.endArrival)"
          description = carPooling.description
          
          let cell       = self.tableView.cellForRowAtIndexPath(indexPath) as! EditableCarPoolingTableViewCell
          cell.selected  = false
          
          updateHandler = { _ in
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddUpdateCarPoolingViewController") as! AddUpdateCarPoolingViewController
            controller.delegate = self
            controller.carPooling = carPooling
            self.presentViewController(controller, animated: true, completion: nil)
            
          }
          
        } else {
          let event = self.viewModel.eventsCreated[indexPath.row]
          title = event.title
          description = event.description
          let cell       = self.tableView.cellForRowAtIndexPath(indexPath) as! EditableEventTableViewCell
          cell.selected  = false
          
          updateHandler = { _ in
            let eventController = self.storyboard!.instantiateViewControllerWithIdentifier("AddUpdateEventViewController") as! AddUpdateEventViewController
            eventController.delegate = self
            eventController.event = event
            self.presentViewController(eventController, animated: true, completion: nil)
          }
        }
        
        optionController = UIAlertController(title: title, message: description, preferredStyle: .ActionSheet)
        
        optionController.addAction(UIAlertAction(title: "Modifier", style: .Default, handler: updateHandler))
        
        optionController.addAction(UIAlertAction(title: "Supprimer", style: .Default) { _ in
          self.deleteRowAtIndexPath(indexPath)
          })
        
        optionController.addAction(UIAlertAction(title: "Annuler", style: .Cancel) { _ in
          self.tableView.setEditing(false, animated: false)
          })
        
        self.presentViewController(optionController, animated: true, completion: nil)
        
        
      }.addDisposableTo(disposeBag)
    
    tableView
      .rx_itemDeleted
      .asDriver()
      .driveNext { indexPath in
        self.deleteRowAtIndexPath(indexPath)
      }.addDisposableTo(disposeBag)
  }
  
  func deleteRowAtIndexPath(indexPath: NSIndexPath) {
    
    let confirmDeletionController: UIAlertController
    let deletionHandler: (UIAlertAction) -> ()
    let title: String
    let itemDescription: String
    
    if self.categoryFilter == ProfileNavigationFilter.LostObject {
      
      let lostObject = self.viewModel.lostObjectsCreated[indexPath.row]
      title = lostObject.title
      itemDescription = "l'objet perdu"
      
      deletionHandler = { _ in
        
        AWLoader.show()
        self.viewModel.delete(lostObject) { response, error in
          
          self.tableView.setEditing(false, animated: false)
          
          guard error == nil else {
            AWLoader.hide()
            self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
            return
          }
          
          self.viewModel.lostObjectsCreated = self.viewModel.lostObjectsCreated.filter { $0.id != lostObject.id }
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
          self.displayOrUpdateNavigationFilterBar()
          AWLoader.hide()
          
        }
      }
      
    } else if self.categoryFilter == ProfileNavigationFilter.Advertisment {
      
      let advertisment = self.viewModel.advertismentsCreated[indexPath.row]
      title = advertisment.title
      itemDescription = "L'annonce"
      
      deletionHandler = { _ in
        
        AWLoader.show()
        self.viewModel.delete(advertisment) { response, error in
          
          self.tableView.setEditing(false, animated: false)
          
          guard error == nil else {
            AWLoader.hide()
            self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
            return
          }
          
          self.viewModel.advertismentsCreated = self.viewModel.advertismentsCreated.filter { $0.id != advertisment.id }
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
          self.displayOrUpdateNavigationFilterBar()
          AWLoader.hide()
          
        }
      }
      
    } else {
      let event = self.viewModel.eventsCreated[indexPath.row]
      itemDescription = "l'événement"
      title = event.title
      
      deletionHandler = { _ in
        
        AWLoader.show()
        self.viewModel.delete(event) { response, error in
          
          self.tableView.setEditing(false, animated: false)
          
          guard error == nil else {
            self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
            return
          }
          
          self.viewModel.eventsCreated = self.viewModel.eventsCreated.filter { $0.id != event.id }
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
          self.displayOrUpdateNavigationFilterBar()
          AWLoader.hide()
        }
      }
    }
    
    confirmDeletionController = UIAlertController(title: title, message: "En continuant, \(itemDescription) sera définitivement supprimé de la liste.", preferredStyle: .ActionSheet)
    
    let deleteAction = UIAlertAction(title: "Supprimer", style: .Destructive, handler: deletionHandler)
    
    let cancelAction = UIAlertAction(title: "Annuler", style: .Cancel) { _ in
      self.tableView.setEditing(false, animated: false)
    }
    
    confirmDeletionController.addAction(deleteAction)
    confirmDeletionController.addAction(cancelAction)
    
    self.presentViewController(confirmDeletionController, animated: true, completion: nil)
    
    
  }
  
  @IBAction func filterTableView(sender: UIButton) {
    categoryFilter = ProfileNavigationFilter(rawValue: sender.tag)!
    
    [eventFilterButton, carPoolingFilterButton, advertismentFilterButton, lostObjectFilterButton].forEach {
      $0.selected = false
    }
    
    sender.selected = true
    
    tableView.reloadData()
  }
}


// MARK: - Table View Datasource -

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  
  private struct TableViewCellIdentifier {
    static let lostObject   = "LostObjectCell"
    static let event        = "EventCell"
    static let advertisment = "AdvertisementCell"
    static let carPooling   = "CarPoolingCell"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if categoryFilter == ProfileNavigationFilter.LostObject {
      let lostObject             = viewModel.lostObjectsCreated[indexPath.row]
      let cell                   = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.lostObject,
                                                                               forIndexPath: indexPath) as! EditableLostObjectTableViewCell
      cell.titleLabel.text       = lostObject.title
      cell.descriptionLabel.text = lostObject.description
      cell.descriptionLabel.text = lostObject.description
      cell.foundLabel.text       = viewModel.foundTextForBoolean(lostObject.found)
      return cell
      
    } else if categoryFilter == .Advertisment {
      let advertisment                    = viewModel.advertismentsCreated[indexPath.row]
      let cell                             = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.advertisment, forIndexPath: indexPath) as! EditableAdvertismentTableViewCell
      cell.titleLabel.text       = advertisment.title
      cell.descriptionLabel.text = advertisment.description
      cell.priceLabel.attributedText       = advertisment.price.formatPrice()
      
      if advertisment.price == 0 {
        cell.rightPriceMarginConstraint.constant = -91 // ( -113 : width of price label, 22 : right margin )
      } else {
        cell.dateLabel.text = NSDateFormatter.frenchDateFormatter.stringFromDate(advertisment.createdDate.toDate())
        cell.rightPriceMarginConstraint.constant = 0.0
      }
      
      cell.typeLabel.text = advertisment.type.rawValue
      
      return cell
      
    } else if categoryFilter == .CarPooling {
      let cell       = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.carPooling, forIndexPath: indexPath) as! EditableCarPoolingTableViewCell
      let carPooling = viewModel.carsPoolingCreated[indexPath.row]
      
      cell.startDateLabel.text               = NSDateFormatter.frenchDateFormatter.stringFromDate(carPooling.startDate.toDate())
      cell.startLocationLabel.text = carPooling.startArrival
      cell.endLocationLabel.text             = carPooling.endArrival
      cell.priceLabel.text                   = "\(carPooling.price)"
      cell.numberOfSeatsLabel.text = "\(carPooling.seatAvailable)"
      
      return cell
      
    }
    else {
      let event                  = viewModel.eventsCreated[indexPath.row]
      let cell                   = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.event,
                                                                               forIndexPath: indexPath) as! EditableEventTableViewCell
      cell.titleLabel.text       = event.title
      cell.descriptionLabel.text = event.description
      cell.locationLabel.text    = event.location
      cell.categoryLabel.text    = viewModel.categoryTextForCategoryIndex(event.type.hashValue)
      return cell
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if categoryFilter == .LostObject {
      return viewModel.lostObjectsCreated.count
    } else if categoryFilter == .Event {
      return viewModel.eventsCreated.count
    } else if categoryFilter == .Advertisment {
      return viewModel.advertismentsCreated.count
    } else {
      return viewModel.carsPoolingCreated.count
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch categoryFilter {
    case .Advertisment: return 160
    case .LostObject: return 130
    case .Event: return 146
    case .CarPooling: return 127
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

extension ProfileViewController: AddUpdateLostObjectViewControllerDelegate {
  func addLostObjectViewController(controller: AddUpdateLostObjectViewController,
                                   didFinishWithTitle title: String, description: String, found: Bool, location: String?) {
    // Implemented in the LostObject controller
  }
  
  
  
  func updateLostObjectViewController(controller: AddUpdateLostObjectViewController, didFinishWithUpdatedLostObject lostObject: LostObject) {
    controller.dismissViewControllerAnimated(true, completion: nil)
    
    AWLoader.show()
    self.viewModel.update(lostObject) { response, error in
      
      guard error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      let indexLostObject = self.viewModel.lostObjectsCreated.indexOf { lostObject.id == $0.id }!
      self.viewModel.lostObjectsCreated[indexLostObject] = lostObject
      self.tableView.reloadData()
      AWLoader.hide()
    }
  }
}

extension ProfileViewController: AddUpdateEventViewControllerDelegate {
  
  func addEventViewController(controller: AddUpdateEventViewController, didFinishWithTitle title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType) {
    // Implemented in the Event controller
  }
  
  func updateEventViewController(controller: AddUpdateEventViewController, didFinishWithUpdatedEvent event: Event) {
    controller.dismissViewControllerAnimated(true, completion: nil)
    
    AWLoader.show()
    
    self.viewModel.update(event) { response, error in
      
      guard error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      let indexEvent = self.viewModel.eventsCreated.indexOf { event.id == $0.id }!
      self.viewModel.eventsCreated[indexEvent] = event
      self.tableView.reloadData()
      AWLoader.hide()
    }
    
  }
}

extension ProfileViewController: AddUpdateAdvertismentViewControllerDelegate {
  
  func addAdvertismentViewController(controller: AddUpdateAdvertismentViewController, didFinishWithTitle title: String, description: String, price: Float, type: AdvertismentType) {
    // Implemented in the Advertisment controller
  }
  
  func updateAdvertismentViewController(controller: AddUpdateAdvertismentViewController, didFinishWithUpdatedAdvertisment advertisment: Advertisment) {
    controller.dismissViewControllerAnimated(true, completion: nil)
    
    AWLoader.show()
    
    self.viewModel.update(advertisment) { response, error in
      
      AWLoader.hide()
      
      guard error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      let indexAdvertisment = self.viewModel.advertismentsCreated.indexOf { advertisment.id == $0.id }!
      self.viewModel.advertismentsCreated[indexAdvertisment] = advertisment
      self.tableView.reloadData()
    }
    
  }
}


extension ProfileViewController: AddUpdateCarPoolingViewControllerDelegate {
  
  func addCarPoolingViewController(controller: AddUpdateCarPoolingViewController, didFinishWithStartLocation startLocation: String, endLocation: String, startDate: String, price: Float, numberOfSeat: Int, description: String) {
    // Implemented in the CarPooling controller
  }
  
  func updateCarPoolingViewController(controller: AddUpdateCarPoolingViewController, didFinishWithUpdatedCarPooling carPooling: CarPooling) {
    
    controller.dismissViewControllerAnimated(true, completion: nil)
    
    
    AWLoader.show()
    
    self.viewModel.update(carPooling) { response, error in
      
      AWLoader.hide()
      
      guard error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      let indexCarPooling = self.viewModel.advertismentsCreated.indexOf { carPooling.id == $0.id }!
      self.viewModel.carsPoolingCreated[indexCarPooling] = carPooling
      self.tableView.reloadData()
    }
    
  }
}


