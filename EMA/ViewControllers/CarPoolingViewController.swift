//
//  CarPoolingViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 23/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

class CarPoolingViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
    }
  }
  
  @IBOutlet weak var locationFilterSegmentedControl: UISegmentedControl!
  
  var isFilterToStart: Bool {
    return locationFilterSegmentedControl.selectedSegmentIndex == 0
  }
  
  let refreshControl = UIRefreshControl()

  var viewModel: CarPoolingViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.addSubview(refreshControl)
    
    refreshControl
      .rx_controlEvent(.ValueChanged)
      .asDriver()
      .driveNext {
        self.fetchAllCarsPooling(byShowingLoader: false)
      }.addDisposableTo(disposeBag)
    
    bindView()

    fetchAllCarsPooling(byShowingLoader: true)
  }
  
  
  
  func fetchAllCarsPooling(byShowingLoader showLoader: Bool) {
    if showLoader {
      AWLoader.show()
    }
    
    viewModel.fetchAllCarsPooling() { response in
      AWLoader.hide()
      
      if self.refreshControl.refreshing {
          self.refreshControl.endRefreshing()
      }
      
      guard let carsPooling = response.response?.carsPooling where response.error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      self.viewModel.carsPooling = carsPooling
      self.tableView.reloadData()
    }

  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destinationController = segue.destinationViewController as? AddUpdateCarPoolingViewController {
      cancelSearch()
      destinationController.delegate = self
    }
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    
    // When canceling the search bar
    searchBar
      .rx_cancelButtonClicked
      .asDriver()
      .driveNext {
        self.cancelSearch()
      }.addDisposableTo(disposeBag)
    
    // When focus on the search bar
    searchBar
      .rx_searchBarBeginEditing
      .asDriver()
      .driveNext {
        self.searchBar.setShowsCancelButton(true, animated: true)
      }.addDisposableTo(disposeBag)
    
    // When searching
    searchBar
      .rx_text
      .asDriver()
      .driveNext {
        self.viewModel.searchFilter = $0
        self.tableView.reloadData()
      }.addDisposableTo(disposeBag)
    
    
    // When clicking on the cell
    tableView
      .rx_itemSelected
      .asDriver()
      .driveNext { indexPath in
        let carPooling = self.viewModel.currentCarsPooling[indexPath.row]
        let cell       = self.tableView.cellForRowAtIndexPath(indexPath)!
        cell.selected  = false
        
        let contactController = UIAlertController(title: "\(carPooling.startArrival) --> \(carPooling.endArrival)", message: carPooling.description, preferredStyle: .ActionSheet)
        contactController.popoverPresentationController?.sourceView = cell
        
        // If there is a phone number, we add the possibility to call and to send a sms
        if let phoneNumber = carPooling.creatorPhoneNumber {
          contactController.addAction(UIAlertAction(title: "Appeler", style: .Default) { _ in
            if  let phoneUrl = NSURL(string: "tel:\(phoneNumber)") {
              UIApplication.sharedApplication().openURL(phoneUrl)
            }
          })
          
          if(MFMessageComposeViewController.canSendText()) {
            contactController.addAction(UIAlertAction(title: "Envoyer un SMS", style: .Default) { _ in
              let smsController = MFMessageComposeViewController()
              smsController.recipients = [phoneNumber]
              smsController.messageComposeDelegate = self
              
              self.presentViewController(smsController, animated: true, completion: nil)
            })
          }
        }
        
          contactController.addAction(UIAlertAction(title: "Envoyer un email", style: .Default) { _ in
            let mailController = MFMailComposeViewController(subject: "Covoiturages - \(carPooling.startArrival) --> \(carPooling.endArrival)", recipient: carPooling.creatorLogin!.toMinesAlesEmail(), delegate: self)
            self.presentViewController(mailController, animated: true, completion: nil)
            })
        
        
        contactController.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: nil))
        
        self.presentViewController(contactController, animated: true, completion: nil)
      }.addDisposableTo(disposeBag)
  }

  @IBAction func filterCarsPooling(sender: AnyObject) {
    self.viewModel.filterStartLocation = locationFilterSegmentedControl.selectedSegmentIndex == 0
    self.tableView.reloadData()
  }
  
  func cancelSearch() {
    self.view.endEditing(true)
    self.searchBar.text   = ""
    self.viewModel.searchFilter = ""
    self.searchBar.setShowsCancelButton(false, animated: false)
    self.tableView.reloadData()
  }
}

extension CarPoolingViewController: UITableViewDataSource, UITableViewDelegate {
  
  private struct TableViewCell {
    static let identifier = "CarPooling"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell       = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier, forIndexPath: indexPath) as! CarPoolingTableViewCell
    let carPooling = viewModel.currentCarsPooling[indexPath.row]

    cell.creatorNameLabel.text             = carPooling.creatorName
    cell.startDateLabel.text               = NSDateFormatter.frenchDateFormatter.stringFromDate(carPooling.startDate.toDate())
    cell.startLocationLabel.attributedText = viewModel.filterFormatted(carPooling.startArrival)
    cell.endLocationLabel.attributedText             = viewModel.filterFormatted(carPooling.endArrival)
    cell.priceLabel.text                   = viewModel.formatPrice(carPooling.price)
    cell.numberOfSeatsLabel.attributedText = viewModel.formatNumberOfSeats(carPooling.seatAvailable)
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.currentCarsPooling.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

// MARK: - SMS Controller Delegate -

extension CarPoolingViewController: MFMessageComposeViewControllerDelegate {
  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - Mail Controller Delegate -

extension CarPoolingViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}


extension CarPoolingViewController: AddUpdateCarPoolingViewControllerDelegate {
  
  func addCarPoolingViewController(controller: AddUpdateCarPoolingViewController, didFinishWithStartLocation startLocation: String, endLocation: String, startDate: String, price: Float, numberOfSeat: Int, description: String) {
    controller.dismissViewControllerAnimated(true, completion: nil)
    
    AWLoader.show()
    let createdDate = NSDateFormatter.dateFormatter.stringFromDate(NSDate())
    self.viewModel.addCarPooling(startLocation, endLocation: endLocation, startDate: startDate, createdDate: createdDate, price: price, numberOfSeats: numberOfSeat, description: description, creatorId: NSUserDefaults.standardUserDefaults().id) { response, error in
      
      AWLoader.hide()
      
      guard let carPoolingId = response?.id where error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      let carPoolingCreated = CarPooling(id: carPoolingId, startArrival: startLocation, endArrival: endLocation, startDate: startDate, createdDate: createdDate, description: description, price: price, seatAvailable: numberOfSeat, creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login)
    
      self.viewModel.carsPooling.append(carPoolingCreated)
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
      }
    }
  }
  
  func updateCarPoolingViewController(controller: AddUpdateCarPoolingViewController, didFinishWithUpdatedCarPooling carPooling: CarPooling) {
    // Implemented in the CarPooling controller
      }
}
