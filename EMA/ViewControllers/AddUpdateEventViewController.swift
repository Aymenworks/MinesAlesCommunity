//
//  AddUpdateEventViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 31/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
  convenience init(delegate: SBFLatDatePickerDelegate) {
    self.init()
    let datePicker = SBFlatDatePicker(frame: self.view.bounds)
    datePicker.delegate = delegate
    datePicker.backgroundColor = UIColor.mainGreyColor()
    datePickerMainColor = UIColor.minesAlesColor()
    self.view = datePicker
  }
}

protocol AddUpdateEventViewControllerDelegate: class {
  func addEventViewController(controller: AddUpdateEventViewController, didFinishWithTitle title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType)
  func updateEventViewController(controller: AddUpdateEventViewController, didFinishWithUpdatedEvent event: Event)
}
  
class AddUpdateEventViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var viewControllerTitle: UILabel!
  @IBOutlet weak var eventCategorySegmentedControl: UISegmentedControl!
  @IBOutlet weak var eventTitleTextField: UITextField!
  @IBOutlet weak var eventLocationTextField: UITextField!
  
  @IBOutlet weak var eventStartDateTextField: UITextField! {
    didSet {
      eventStartDateTextField.inputView = UIView()
    }
  }
  
  @IBOutlet weak var eventEndDateTextField: UITextField! {
    didSet {
      eventEndDateTextField.inputView = UIView()
    }
  }
  
  @IBOutlet weak var addEventButton: UIButton!
  @IBOutlet weak var eventDescriptionTextView: UITextView!
  @IBOutlet weak var keyboardBarViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var datePickerViewController: UIViewController!
  
  var startDate: NSDate? {
    didSet {
      eventStartDateTextField.text = "Début : \(NSDateFormatter.dateFormatter.stringFromDate(startDate!))"
      dateChose.value = !eventStartDateTextField.text!.isEmpty && !eventEndDateTextField.text!.isEmpty
    }
  }
  
  var endDate: NSDate? {
    didSet {
      eventEndDateTextField.text = "Fin : \(NSDateFormatter.dateFormatter.stringFromDate(endDate!))"
      dateChose.value = !eventStartDateTextField.text!.isEmpty && !eventEndDateTextField.text!.isEmpty
    }
  }
  
  var dateChose = Variable(false)
  
  var isStartDatePicker = true
  var event: Event?
  var delegate: AddUpdateEventViewControllerDelegate?
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    eventTitleTextField.becomeFirstResponder()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddUpdateEventViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddUpdateEventViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    // If we have the lost object setted, it means it's an UPDATE
    if let event = event {
      viewControllerTitle.text = "Modifier l'événement"
      eventTitleTextField.text = event.title
      eventLocationTextField.text = event.location
      startDate = event.startDate.toDate()
      endDate = event.endDate.toDate()
      eventDescriptionTextView.text = event.description
      eventCategorySegmentedControl.selectedSegmentIndex = event.type.hashValue
      addEventButton.setTitle("Modifier", forState: .Normal)
    }
    
    bindView()
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    eventTitleTextField
      .rx_controlEvent(.EditingDidEndOnExit)
      .asObservable()
      .subscribeNext {
        self.eventLocationTextField.becomeFirstResponder()
    }.addDisposableTo(disposeBag)
    
    eventStartDateTextField
      .rx_controlEvent(.EditingDidBegin)
      .asDriver()
      .driveNext {
        self.isStartDatePicker = true
        self.datePickerViewController = UIViewController(delegate: self)
        self.presentViewController(self.datePickerViewController, animated: true, completion: nil)
      }.addDisposableTo(disposeBag)
    
    eventEndDateTextField
      .rx_controlEvent(.EditingDidBegin)
      .asDriver()
      .driveNext {
        self.isStartDatePicker = false
        self.datePickerViewController = UIViewController(delegate: self)
        self.presentViewController(self.datePickerViewController, animated: true, completion: nil)
      }.addDisposableTo(disposeBag)
    

    let titleValidation = eventTitleTextField.rx_text.map(emptyValidation)
    let locationValidation = eventLocationTextField.rx_text.map(emptyValidation)
    let descriptionValidation = eventDescriptionTextView.rx_text.map(emptyValidation)
    let dateChoseValidation = dateChose.asObservable()
    
    let enableButton = Observable.combineLatest(titleValidation, locationValidation, descriptionValidation, dateChoseValidation) { title, location, description, dateChose in
      return title && location && description && dateChose
    }
    
    enableButton
      .asObservable()
      .doOnNext { enabled in
        self.addEventButton.backgroundColor = enabled ? UIColor.minesAlesColor() : UIColor.lightGrayColor()
    }.bindTo(addEventButton.rx_enabled)
    .addDisposableTo(disposeBag)
    
    addEventButton
      .rx_tap
      .asDriver()
      .driveNext {
        self.view.endEditing(true)
        
        if var event = self.event {
          event.title = self.eventTitleTextField.text!
          event.description = self.eventDescriptionTextView.text
          event.location = self.eventLocationTextField.text!
          event.startDate = NSDateFormatter.dateFormatter.stringFromDate(self.startDate!)
          event.endDate = NSDateFormatter.dateFormatter.stringFromDate(self.endDate!)
          event.type = self.categoryForCurrentSelectedIndex()
          self.delegate?.updateEventViewController(self, didFinishWithUpdatedEvent: event)
          
        } else {
          self.delegate?.addEventViewController(self, didFinishWithTitle: self.eventTitleTextField.text!, location: self.eventLocationTextField.text!, startDate: NSDateFormatter.dateFormatter.stringFromDate(self.startDate!), endDate: NSDateFormatter.dateFormatter.stringFromDate(self.endDate!), createdDate: NSDateFormatter.dateFormatter.stringFromDate(NSDate()), description: self.eventDescriptionTextView.text, type: self.categoryForCurrentSelectedIndex())
        }

      }.addDisposableTo(disposeBag)
  }
  
  func categoryForCurrentSelectedIndex() -> EventType {
    switch eventCategorySegmentedControl.selectedSegmentIndex {
    case 0: return .Party
    case 1: return .Outings
    case 2: return .Sport
    default: return .Various
    }
  }
}

// MARK: - UIKeyboard Notification -

extension AddUpdateEventViewController {
  
  func keyboardWillShow(notification: NSNotification) {
    let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.0, options: .CurveLinear,
                               animations: { self.keyboardBarViewConstraint.constant = keyboardHeight ; self.view.layoutIfNeeded()}, completion: nil)
  }
  
  func keyboardWillHide(notification: NSNotification) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.0, options: .CurveLinear,
                               animations: { self.keyboardBarViewConstraint.constant = 0 ; self.view.layoutIfNeeded()}, completion: nil)
  }
}

// MARK: - Reminder Picker Delegate -

extension AddUpdateEventViewController: SBFLatDatePickerDelegate {
  func flatDatePicker(datePicker: SBFlatDatePicker!, saveDate date: NSDate!) {
    datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
    
    if isStartDatePicker {
      startDate = date
    } else {
      endDate = date
    }
  }
  
  func datePickerDidCancel(datePicker: SBFlatDatePicker!) {
    datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}