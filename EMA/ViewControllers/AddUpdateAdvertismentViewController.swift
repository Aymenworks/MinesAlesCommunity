//
//  AddUpdateAdvertismentViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import ParkedTextField

protocol AddUpdateAdvertismentViewControllerDelegate: class {
  func updateAdvertismentViewController(controller: AddUpdateAdvertismentViewController, didFinishWithUpdatedAdvertisment advertisment: Advertisment)
  func addAdvertismentViewController(controller: AddUpdateAdvertismentViewController, didFinishWithTitle title: String, description: String, price: Float, type: AdvertismentType)
}

class AddUpdateAdvertismentViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var viewControllerTitle: UILabel!
  @IBOutlet weak var advertismentTypeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var advertismentTitleTextField: UITextField!
  @IBOutlet weak var advertismentPriceTextField: ParkedTextField!
  @IBOutlet weak var addAdvertismentButton: UIButton!
  @IBOutlet weak var advertismentDescriptionTextView: UITextView!
  @IBOutlet weak var keyboardBarViewConstraint: NSLayoutConstraint!
  
  var advertisment: Advertisment?
  var delegate: AddUpdateAdvertismentViewControllerDelegate?
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    advertismentTitleTextField.becomeFirstResponder()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddUpdateAdvertismentViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
    // If we have the advertisment object setted, it means it's an UPDATE
    if let advertisment = advertisment {
      viewControllerTitle.text = "Modifier l'annonce"
      advertismentTitleTextField.text = advertisment.title
      advertismentPriceTextField.typedText = "\(Int(advertisment.price))"
      advertismentDescriptionTextView.text = advertisment.description
      advertismentTypeSegmentedControl.selectedSegmentIndex = advertisment.type.hashValue
      addAdvertismentButton.setTitle("Modifier", forState: .Normal)
    }
    
    bindView()
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    advertismentTitleTextField
      .rx_controlEvent(.EditingDidEndOnExit)
      .asObservable()
      .subscribeNext {
        self.advertismentDescriptionTextView.becomeFirstResponder()
      }.addDisposableTo(disposeBag)
    
    
    let titleValidation = advertismentTitleTextField.rx_text.map(emptyValidation)
    let descriptionValidation = advertismentDescriptionTextView.rx_text.map(emptyValidation)
    
    let enableButton = Observable.combineLatest(titleValidation, descriptionValidation) { title, description in
      return title && description
    }
    
    enableButton
      .asObservable()
      .doOnNext { enabled in
        self.addAdvertismentButton.backgroundColor = enabled ? UIColor.minesAlesColor() : UIColor.lightGrayColor()
      }.bindTo(addAdvertismentButton.rx_enabled)
      .addDisposableTo(disposeBag)
    
    addAdvertismentButton
      .rx_tap
      .asDriver()
      .driveNext {
        self.view.endEditing(true)
        
        if var advertisment = self.advertisment {
          advertisment.title = self.advertismentTitleTextField.text!
          advertisment.description = self.advertismentDescriptionTextView.text
          advertisment.type = self.typeForCurrentSelectedIndex()
          advertisment.price = Float(self.advertismentPriceTextField.typedText)!
          self.delegate?.updateAdvertismentViewController(self, didFinishWithUpdatedAdvertisment: advertisment)
          
        } else {
          self
          self.delegate?.addAdvertismentViewController(self, didFinishWithTitle: self.advertismentTitleTextField.text!, description: self.advertismentDescriptionTextView.text!, price: Float(self.advertismentPriceTextField.typedText) ?? 0.0, type: self.typeForCurrentSelectedIndex())

        }
      }.addDisposableTo(disposeBag)
    }
  
  func typeForCurrentSelectedIndex() -> AdvertismentType {
    switch advertismentTypeSegmentedControl.selectedSegmentIndex {
    case 0: return .Sale
    case 1: return .Renting
    case 2: return .Various
    default: return .Various
    }
  }
}

// MARK: - UIKeyboard Notification -

extension AddUpdateAdvertismentViewController: UITextFieldDelegate {
  
  func keyboardWillShow(notification: NSNotification) {
    let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.0, options: .CurveLinear,
                               animations: { self.keyboardBarViewConstraint.constant = keyboardHeight ; self.view.layoutIfNeeded()}, completion: nil)
  }
}
