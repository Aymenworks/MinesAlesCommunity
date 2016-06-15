//
//  AddCarPoolingViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 31/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import ParkedTextField

let emptyValidation: ((String) -> Bool) = {
    return !$0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).isEmpty
}

protocol AddUpdateCarPoolingViewControllerDelegate: class {
  func updateCarPoolingViewController(controller: AddUpdateCarPoolingViewController, didFinishWithUpdatedCarPooling carPooling: CarPooling)
  func addCarPoolingViewController(controller: AddUpdateCarPoolingViewController, didFinishWithStartLocation startLocation: String, endLocation: String, startDate: String, price: Float, numberOfSeat: Int, description: String)
}
  
class AddUpdateCarPoolingViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var viewControllerTitle: UILabel!
  @IBOutlet weak var startDateTextField: UITextField!
  @IBOutlet weak var startLocationTextField: UITextField!
  @IBOutlet weak var endLocationTextField: UITextField!

  @IBOutlet weak var addCarPoolingButton: UIButton!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var priceTextField: ParkedTextField!
  @IBOutlet weak var numberOfSeatsTextField: ParkedTextField!
  @IBOutlet weak var keyboardBarViewConstraint: NSLayoutConstraint!

  var carPooling: CarPooling?
  var delegate: AddUpdateCarPoolingViewControllerDelegate?
  
  var datePickerViewController: UIViewController!
  
  let disposeBag = DisposeBag()
  
  var startDate: NSDate? {
    didSet {
      startDateTextField.text = "\(NSDateFormatter.frenchDateFormatter.stringFromDate(startDate!))"
      dateChose.value = !startDateTextField.text!.isEmpty
    }
  }

  var dateChose = Variable(false)
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLocationTextField.becomeFirstResponder()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddUpdateCarPoolingViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
    // If we have the lost object setted, it means it's an UPDATE
    if let carPooling = carPooling {
      viewControllerTitle.text         = "Modifier le covoiturage"
      startDate                        = carPooling.startDate.toDate()
      startLocationTextField.text      = carPooling.startArrival
      endLocationTextField.text        = carPooling.endArrival
      descriptionTextView.text         = carPooling.description
      priceTextField.typedText         = "\(carPooling.price)"
      numberOfSeatsTextField.typedText = "\(carPooling.seatAvailable)"
    }
    
    bindView()
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    startDateTextField
      .rx_controlEvent(.EditingDidEndOnExit)
      .asObservable()
      .subscribeNext {
        self.endLocationTextField.becomeFirstResponder()
    }.addDisposableTo(disposeBag)
    
    let startLocationValidation = startLocationTextField.rx_text.map(emptyValidation)
    let endLocationValidation   = endLocationTextField.rx_text.map(emptyValidation)
    let priceValidation         = priceTextField.rx_text.map(emptyValidation)
    let numberOfSeatValidation  = numberOfSeatsTextField.rx_text.map(emptyValidation)
    let descriptionValidation   = descriptionTextView.rx_text.map(emptyValidation)
    let startDateValidation     = dateChose.asObservable()

    let enableButton = Observable.combineLatest(startLocationValidation, endLocationValidation, descriptionValidation, startDateValidation, priceValidation, numberOfSeatValidation) { a, b, c, d, _, _ in
      return a && b && c && d && !self.numberOfSeatsTextField.typedText.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).isEmpty && !self.priceTextField.typedText.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).isEmpty
    }
    
    enableButton
      .asObservable()
      .doOnNext { enabled in
        self.addCarPoolingButton.backgroundColor = enabled ? UIColor.minesAlesColor() : UIColor.lightGrayColor()
    }.bindTo(addCarPoolingButton.rx_enabled)
    .addDisposableTo(disposeBag)
    
    startDateTextField
      .rx_controlEvent(.EditingDidBegin)
      .asDriver()
      .driveNext {
        self.datePickerViewController = UIViewController(delegate: self)
        self.presentViewController(self.datePickerViewController, animated: true, completion: nil)
      }.addDisposableTo(disposeBag)

    
    addCarPoolingButton
      .rx_tap
      .asDriver()
      .driveNext {
        self.view.endEditing(true)
        
        if var carPooling = self.carPooling {
          carPooling.startArrival = self.startLocationTextField.text!
          carPooling.endArrival = self.endLocationTextField.text!
          carPooling.description = self.descriptionTextView.text!
          carPooling.startDate = NSDateFormatter.dateFormatter.stringFromDate(self.startDate!)
          carPooling.price = Float(self.priceTextField.text!)!
          carPooling.seatAvailable = Int(self.numberOfSeatsTextField.typedText)!
          self.delegate?.updateCarPoolingViewController(self, didFinishWithUpdatedCarPooling: carPooling)
          
        } else {
          self.delegate?.addCarPoolingViewController(self, didFinishWithStartLocation: self.startLocationTextField.text!, endLocation: self.endLocationTextField.text!, startDate: NSDateFormatter.dateFormatter.stringFromDate(self.startDate!), price: Float(self.priceTextField.typedText)!, numberOfSeat: Int(self.numberOfSeatsTextField.typedText)!, description: self.descriptionTextView.text!)

        }
        
      }.addDisposableTo(disposeBag)
  }
}


// MARK: - UIKeyboard Notification -

extension AddUpdateCarPoolingViewController: UITextFieldDelegate {
  
  func keyboardWillShow(notification: NSNotification) {
      let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.0, options: .CurveLinear,
                                 animations: { self.keyboardBarViewConstraint.constant = keyboardHeight ; self.view.layoutIfNeeded()}, completion: nil)
    }
}

// MARK: - Reminder Picker Delegate -

extension AddUpdateCarPoolingViewController: SBFLatDatePickerDelegate {
  func flatDatePicker(datePicker: SBFlatDatePicker!, saveDate date: NSDate!) {
    datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
    startDate = date
    }

  
  func datePickerDidCancel(datePicker: SBFlatDatePicker!) {
    datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}
