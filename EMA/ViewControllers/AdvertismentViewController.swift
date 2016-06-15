
//
//  AdvertisementViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

enum AdvertismentNavigationFilter: Int {
  case Sale, Rent, Various
}

class AdvertismentViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var saleFilterButton: FilterButton! {
    didSet {
      saleFilterButton.selected = true
    }
  }
  
  @IBOutlet weak var rentFilterButton: FilterButton!
  @IBOutlet weak var variousFilterButton: FilterButton!
  
  var allFiltersButton: [UIButton] {
    return [self.saleFilterButton, self.rentFilterButton, self.variousFilterButton]
  }
  
  
  @IBOutlet weak var tableView: UITableView!
  let refreshControl = UIRefreshControl()
  
  var viewModel: AdvertismentViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.addSubview(refreshControl)

    bindView()
    
    fetchAllAdvertisments(byShowingLoader: true)

    }
  
  func fetchAllAdvertisments(byShowingLoader showLoader: Bool) {
    if showLoader {
      AWLoader.show()
    }
    
    viewModel.fetchAllAdvertisements { response, error in
      
      if self.refreshControl.refreshing {
        self.refreshControl.endRefreshing()
      }
      
      guard error == nil else {
        AWLoader.hide()
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      if let advertisements = response?.advertisements {
        self.viewModel.advertisements = advertisements
      }
      
      for (index,button) in
        self.allFiltersButton.enumerate() {
          button.setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(index), forState: .Normal)
          button.setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(index, textColor: UIColor.filterTextButtonGreyColor()), forState: .Selected)
      }
      
      self.tableView.reloadData()
      AWLoader.hide()
    }

  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     if let destinationController = segue.destinationViewController as? AddUpdateAdvertismentViewController {
     cancelSearch()
     destinationController.delegate = self
     }
  }
  
  func cancelSearch() {
    self.view.endEditing(true)
    self.searchBar.text   = ""
    self.viewModel.searchFilter = ""
    self.searchBar.setShowsCancelButton(false, animated: false)
    self.tableView.reloadData()
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    
    // Refresh table view
    refreshControl
      .rx_controlEvent(.ValueChanged)
      .asDriver()
      .driveNext {
        self.fetchAllAdvertisments(byShowingLoader: false)
      }.addDisposableTo(disposeBag)
    
    // When canceling the search bar
    searchBar
      .rx_cancelButtonClicked
      .asDriver()
      .driveNext {
        self.view.endEditing(true)
        self.searchBar.text   = ""
        self.viewModel.searchFilter = ""
        self.searchBar.setShowsCancelButton(false, animated: false)
        self.tableView.reloadData()
      }.addDisposableTo(disposeBag)
    
    
    // When focus on the search bar, we show the cancel button
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
        let advertisement     = self.viewModel.filteredAdvertisments[indexPath.row]
        let cell      = self.tableView.cellForRowAtIndexPath(indexPath) as! AdvertismentTableViewCell
        cell.selected = false
        
        let contactController = UIAlertController(title: advertisement.title, message: advertisement.description, preferredStyle: .ActionSheet)
        contactController.popoverPresentationController?.sourceView = cell
        
        // If there is a phone number, we add the possibility to call and to send a sms
        if let phoneNumber = advertisement.creatorPhoneNumber {
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
          let mailController = MFMailComposeViewController(subject: "Annonce - \(advertisement.title)", recipient: advertisement.creatorLogin!.toMinesAlesEmail(), delegate: self)
          self.presentViewController(mailController, animated: true, completion: nil)
          })
        
        
        contactController.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: nil))
        
        self.presentViewController(contactController, animated: true, completion: nil)
      }.addDisposableTo(disposeBag)
    
  }
  
  @IBAction func filterEvent(sender: UIButton) {
    viewModel.filter = AdvertismentNavigationFilter(rawValue: sender.tag)!
    allFiltersButton.forEach { $0.selected = false }
    sender.selected = true
    tableView.reloadData()
  }
}

// MARK: - Table View Datasource -

extension AdvertismentViewController: UITableViewDelegate, UITableViewDataSource {
  
  private struct TableViewCell {
    static let identifier = "AdvertisementCell"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let advertisement                    = viewModel.filteredAdvertisments[indexPath.row]
    let cell                             = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier, forIndexPath: indexPath) as! AdvertismentTableViewCell
    cell.titleLabel.attributedText       = viewModel.filterFormatted(advertisement.title, size: 17)
    cell.descriptionLabel.attributedText = viewModel.filterFormatted(advertisement.description)
    cell.priceLabel.attributedText       = advertisement.price.formatPrice()
    cell.dateLabel.text                  = NSDateFormatter.frenchDateFormatter.stringFromDate(advertisement.createdDate.toDate())

    if advertisement.price == 0 {
      cell.rightPriceMarginConstraint.constant = -91 // ( -113 : width of price label, 22 : right margin )
    } else {
      cell.rightPriceMarginConstraint.constant = 0.0
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.filteredAdvertisments.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

// MARK: - SMS Controller Delegate -


extension AdvertismentViewController: MFMessageComposeViewControllerDelegate {
  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - Mail Controller Delegate -

extension AdvertismentViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - Add/Update Controller Delegate -


extension AdvertismentViewController: AddUpdateAdvertismentViewControllerDelegate {
  func addAdvertismentViewController(controller: AddUpdateAdvertismentViewController, didFinishWithTitle title: String, description: String, price: Float, type: AdvertismentType) {
    controller.dismissViewControllerAnimated(true, completion: nil)
    
    AWLoader.show()
    let createdDate = NSDateFormatter.dateFormatter.stringFromDate(NSDate())
    self.viewModel.addAdvertisementWith(title: title, description: description, price: price, createdDate: createdDate, type: type, creatorId: NSUserDefaults.standardUserDefaults().id) { response, error in
      
      AWLoader.hide()

      guard let advertismentCreatedId = response?.id where error == nil else {
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      // Before adding the new advertisment, we select the same filter type as the one the user chose in the creation process
      if type.hashValue != self.viewModel.filter.rawValue {
        self.filterEvent(self.allFiltersButton[type.hashValue])
      }
      
      let advertismentCreated = Advertisment(id: advertismentCreatedId, title: title, description: description, type: type, price: price, createdDate: createdDate, creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login)
      self.viewModel.advertisements.append(advertismentCreated)
      
      // Refresh the title of the filter button (number of events)
      self.allFiltersButton[type.hashValue].setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(type.hashValue), forState: .Normal)
      self.allFiltersButton[type.hashValue].setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(type.hashValue, textColor: UIColor.filterTextButtonGreyColor()), forState: .Selected)
      
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
      }
    }
  }
  
  func updateAdvertismentViewController(controller: AddUpdateAdvertismentViewController, didFinishWithUpdatedAdvertisment advertisment: Advertisment) {
      // Implemented in the Profile controller
  }
}
