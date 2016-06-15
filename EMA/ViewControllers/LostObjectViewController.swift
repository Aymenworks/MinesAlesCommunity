//
//  ViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 23/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

class LostObjectViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var searchObjectBar: UISearchBar!
  
  @IBOutlet weak var lostObjectsTableView: UITableView! {
    didSet {
      lostObjectsTableView.delegate = self
    }
  }
  
  @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
  
  var isFilterSegmentToFound: Bool {
    return filterSegmentedControl.selectedSegmentIndex == 0
  }
  
  let refreshControl = UIRefreshControl()

  var viewModel: LostObjectViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    lostObjectsTableView.addSubview(refreshControl)
    
    refreshControl
      .rx_controlEvent(.ValueChanged)
      .asDriver()
      .driveNext {
        self.fetchAllLostObjects(byShowingLoader: false)
      }.addDisposableTo(disposeBag)
    
    bindView()

    fetchAllLostObjects(byShowingLoader: true)
  }
  
  func fetchAllLostObjects(byShowingLoader showLoader: Bool) {
    if showLoader {
      AWLoader.show()
    }
    viewModel.fetchAllLostObjects() { response in
      AWLoader.hide()
      
      if self.refreshControl.refreshing {
          self.refreshControl.endRefreshing()
      }
      
      guard let lostObjects = response.response?.lostObjects where response.error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      self.viewModel.lostObjects = lostObjects
      self.lostObjectsTableView.reloadData()
    }

  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destinationController = segue.destinationViewController as? AddUpdateLostObjectViewController {
      cancelSearch()
      destinationController.delegate = self
    }
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    
    // When canceling the search bar
    searchObjectBar
      .rx_cancelButtonClicked
      .asDriver()
      .driveNext {
        self.cancelSearch()
      }.addDisposableTo(disposeBag)
    
    // When focus on the search bar
    searchObjectBar
      .rx_searchBarBeginEditing
      .asDriver()
      .driveNext {
        self.searchObjectBar.setShowsCancelButton(true, animated: true)
      }.addDisposableTo(disposeBag)
    
    // When searching
    searchObjectBar
      .rx_text
      .asDriver()
      .driveNext {
        self.viewModel.searchFilter = $0
        self.lostObjectsTableView.reloadData()
      }.addDisposableTo(disposeBag)
    
    
    // When clicking on the cell
    lostObjectsTableView
      .rx_itemSelected
      .asDriver()
      .driveNext { indexPath in
        let lostObject = self.viewModel.currentLostObjects[indexPath.row]
        let cell       = self.lostObjectsTableView.cellForRowAtIndexPath(indexPath) as! LostObjectTableViewCell
        cell.selected  = false
        
        let contactController = UIAlertController(title: lostObject.title, message: lostObject.description, preferredStyle: .ActionSheet)
        contactController.popoverPresentationController?.sourceView = cell
        
        // If there is a phone number, we add the possibility to call and to send a sms
        if let phoneNumber = lostObject.creatorPhoneNumber {
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
            let mailController = MFMailComposeViewController(subject: "Object perdu - \(lostObject.title)", recipient: lostObject.creatorLogin!.toMinesAlesEmail(), delegate: self)
            self.presentViewController(mailController, animated: true, completion: nil)
            })
        
        
        contactController.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: nil))
        
        self.presentViewController(contactController, animated: true, completion: nil)
      }.addDisposableTo(disposeBag)
  }

  @IBAction func filterLostObject(sender: AnyObject) {
    self.viewModel.filterObjectFound = isFilterSegmentToFound
    self.lostObjectsTableView.reloadData()
  }
  
  func cancelSearch() {
    self.view.endEditing(true)
    self.searchObjectBar.text   = ""
    self.viewModel.searchFilter = ""
    self.searchObjectBar.setShowsCancelButton(false, animated: false)
    self.lostObjectsTableView.reloadData()
  }
}

// MARK: - Table View Datasource -

extension LostObjectViewController: UITableViewDataSource, UITableViewDelegate {
  
  private struct TableViewCell {
    static let identifier = "LostObjectCell"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let lostObject                       = viewModel.currentLostObjects[indexPath.row]

    let cell                             = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier, forIndexPath: indexPath) as! LostObjectTableViewCell
    cell.titleLabel.attributedText       = self.viewModel.filterFormatted(lostObject.title, size: 17)
   cell.creatorNameLabel.text           = lostObject.creatorName
    cell.descriptionLabel.attributedText = self.viewModel.filterFormatted(lostObject.description)
    cell.dateLabel.text                  = NSDateFormatter.frenchDateFormatter.stringFromDate(lostObject.createdDate.toDate())
    
    if let location = lostObject.location {
      cell.locationImage.hidden = false
      cell.locationLabel.hidden = false
      cell.locationLabel.attributedText = viewModel.filterFormatted(location)
      
    } else {
      cell.locationImage.hidden = true
      cell.locationLabel.hidden = true
    }
   
    return cell
  }
  

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.currentLostObjects.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

// MARK: - SMS Controller Delegate -

extension LostObjectViewController: MFMessageComposeViewControllerDelegate {
  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - Mail Controller Delegate -

extension LostObjectViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - Add/Update lost object delegate -

extension LostObjectViewController: AddUpdateLostObjectViewControllerDelegate {
 
  func addLostObjectViewController(controller: AddUpdateLostObjectViewController, didFinishWithTitle title: String, description: String, found: Bool, location: String?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  
    AWLoader.show()
    
    self.viewModel.addLostObject(title, description: description, found: found, creatorId: NSUserDefaults.standardUserDefaults().id, location: location ?? "", createdDate: NSDateFormatter.dateFormatter.stringFromDate(NSDate())) { response, error in
      
      AWLoader.hide()
      
      guard let lostObjectCreatedId = response?.id where error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      /* Before adding the new lost object, we select the right segmented control filter ( found / not found ) depending on 
         what has been created
      */
      if found != self.isFilterSegmentToFound {
        self.filterSegmentedControl.selectedSegmentIndex = found ? 0 : 1
        self.filterLostObject(self)
      }
      
      let lostObject = LostObject(id: lostObjectCreatedId, title: title, description: description, location: location ?? "", found: found, creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login, createdDate: NSDateFormatter.dateFormatter.stringFromDate(NSDate()))
      
      self.viewModel.lostObjects.append(lostObject)
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        self.lostObjectsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
      }
    }
  }
  
  func updateLostObjectViewController(controller: AddUpdateLostObjectViewController, didFinishWithUpdatedLostObject lostObject: LostObject) {
      // Implemented in the Profile controller
  }
}
