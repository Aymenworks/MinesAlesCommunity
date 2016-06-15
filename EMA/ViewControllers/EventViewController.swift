//
//  EventViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 03/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

enum EventNavigationFilter: Int {
  case Party, Outings, Sport, Various
}

class EventViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var partyFilterButton: FilterButton! {
    didSet {
      partyFilterButton.selected = true
    }
  }
  
  @IBOutlet weak var outingsFilterButton: FilterButton!
  @IBOutlet weak var sportFiltterButton: FilterButton!
  @IBOutlet weak var variousFilterButton: FilterButton!
  
  var allFiltersButton: [UIButton] {
    return [self.partyFilterButton, self.outingsFilterButton, self.sportFiltterButton, self.variousFilterButton]
  }
  
  let refreshControl = UIRefreshControl()
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: EventViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.addSubview(refreshControl)
    
    refreshControl
      .rx_controlEvent(.ValueChanged)
      .asDriver()
      .driveNext {
        self.fetchAllEvents(byShowingLoader: false)
      }.addDisposableTo(disposeBag)
    
    bindView()
    
    fetchAllEvents(byShowingLoader: true)
  }
  
  func fetchAllEvents(byShowingLoader showLoader: Bool) {
    if showLoader {
      AWLoader.show()
    }
    
    viewModel.fetchAllEvents { response, error in
      
      if self.refreshControl.refreshing {
        self.refreshControl.endRefreshing()
      }
      
      guard error == nil else {
        AWLoader.hide()
        self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
        return
      }
      
      if let events = response?.events {
        self.viewModel.events = events
      }
      
      for (index,button) in
        self.allFiltersButton.enumerate() {
          button.setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(index), forState: .Normal)
          button.setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(index, textColor: UIColor.filterTextButtonGreyColor()), forState: .Selected)
      }
      
      AWLoader.hide()
      self.tableView.reloadData()
    }
  }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let destinationController = segue.destinationViewController as? AddUpdateEventViewController {
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
          let event     = self.viewModel.filteredEvents[indexPath.row]
          let cell      = self.tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
          cell.selected = false
          
          let contactController = UIAlertController(title: event.title, message: event.description, preferredStyle: .ActionSheet)
          contactController.popoverPresentationController?.sourceView = cell
          
          // If there is a phone number, we add the possibility to call and to send a sms
          if let phoneNumber = event.creatorPhoneNumber {
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
            let mailController = MFMailComposeViewController(subject: "Événement - \(event.title)", recipient: event.creatorLogin!.toMinesAlesEmail(), delegate: self)
            self.presentViewController(mailController, animated: true, completion: nil)
            })
          
          
          contactController.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: nil))
          
          self.presentViewController(contactController, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
      
    }
    
    @IBAction func filterEvent(sender: UIButton) {
      viewModel.filter = EventNavigationFilter(rawValue: sender.tag)!
      allFiltersButton.forEach { $0.selected = false }
      sender.selected = true
      tableView.reloadData()
    }
  }
  
  // MARK: - Table View Datasource -
  
  extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    
    private struct TableViewCell {
      static let identifier = "EventCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let event                            = viewModel.filteredEvents[indexPath.row]
      let cell                             = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier, forIndexPath: indexPath) as! EventTableViewCell
      cell.titleLabel.attributedText       = viewModel.filterFormatted(event.title, size: 17)
      cell.descriptionLabel.attributedText = viewModel.filterFormatted(event.description)
      cell.locationLabel.attributedText    = viewModel.filterFormatted(event.location ?? "")
      cell.dateLabel.text        = NSDateFormatter.frenchDateFormatter.stringFromDate(event.startDate.toDate())

      return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.filteredEvents.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
    }
  }
  
  // MARK: - SMS Controller Delegate -
  
  extension EventViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
      controller.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  // MARK: - Mail Controller Delegate -
  
  extension EventViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
      controller.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  // MARK: - Add/Update Controller Delegate -
  
  extension EventViewController: AddUpdateEventViewControllerDelegate {
    func addEventViewController(controller: AddUpdateEventViewController, didFinishWithTitle title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType) {
      controller.dismissViewControllerAnimated(true, completion: nil)
      
      AWLoader.show()
      self.viewModel.addEventWith(title: title, location: location, startDate: startDate, endDate: endDate, createdDate: createdDate, description: description, type: type, creatorId: NSUserDefaults.standardUserDefaults().id) { response, error in
        
        AWLoader.hide()
        
        guard let eventCreatedId = response?.id where error == nil else {
          self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
          return
        }
        
        // Before adding the new event, we select the same filter type as the one the user chose in the creation process
        if type.hashValue != self.viewModel.filter.rawValue {
          self.filterEvent(self.allFiltersButton[type.hashValue])
        }
        
        let eventCreated = Event(id: eventCreatedId, title: title, description: description,   type: type, location: location, startDate: startDate, endDate: endDate, createdDate: NSDateFormatter.dateFormatter.stringFromDate(NSDate()), creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login)
        self.viewModel.events.append(eventCreated)
        
        // Refresh the title of the filter button (number of events)
        self.allFiltersButton[type.hashValue].setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(type.hashValue), forState: .Normal)
        self.allFiltersButton[type.hashValue].setAttributedTitle(self.viewModel.attributeTextForNavigationFilterAtIndex(type.hashValue, textColor: UIColor.filterTextButtonGreyColor()), forState: .Selected)
                
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
          self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
      }
    }
    
    func updateEventViewController(controller: AddUpdateEventViewController, didFinishWithUpdatedEvent event: Event) {
      // Implemented in the Profile controller
    }
    
}

