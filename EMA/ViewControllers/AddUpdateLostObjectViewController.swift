//
//  AddLostObjectViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 31/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift

protocol AddUpdateLostObjectViewControllerDelegate: class {
  func updateLostObjectViewController(controller: AddUpdateLostObjectViewController, didFinishWithUpdatedLostObject lostObject: LostObject)
  func addLostObjectViewController(controller: AddUpdateLostObjectViewController, didFinishWithTitle title: String, description: String, found: Bool, location: String?)
}
  
class AddUpdateLostObjectViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var viewControllerTitle: UILabel!
  @IBOutlet weak var lostObjectFoundSegmentedControl: UISegmentedControl!
  @IBOutlet weak var lostObjectTitleTextField: UITextField!
  @IBOutlet weak var addLostObjectButton: UIButton!
  @IBOutlet weak var lostObjectDescriptionTextView: UITextView!
  @IBOutlet weak var keyboardBarViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var locationTextField: UITextField!

  var lostObject: LostObject?
  var delegate: AddUpdateLostObjectViewControllerDelegate?
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    lostObjectTitleTextField.becomeFirstResponder()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddUpdateLostObjectViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
    // If we have the lost object setted, it means it's an UPDATE
    if let lostObject = lostObject {
      viewControllerTitle.text = "Modifier l'objet perdu"
      lostObjectTitleTextField.text = lostObject.title
      lostObjectDescriptionTextView.text = lostObject.description
      locationTextField.text = lostObject.location
      lostObjectFoundSegmentedControl.selectedSegmentIndex = lostObject.found ? 0 : 1
      addLostObjectButton.setTitle("Modifier", forState: .Normal)
    }
    
    bindView()
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    lostObjectTitleTextField
      .rx_controlEvent(.EditingDidEndOnExit)
      .asObservable()
      .subscribeNext {
        self.lostObjectDescriptionTextView.becomeFirstResponder()
    }.addDisposableTo(disposeBag)
    
    let titleValidation = lostObjectTitleTextField.rx_text.map(emptyValidation)
    let descriptionValidation = lostObjectDescriptionTextView.rx_text.map(emptyValidation)
    
    let enableButton = Observable.combineLatest(titleValidation, descriptionValidation) { title, description in
        return title && description
    }
    
    enableButton
      .asObservable()
      .doOnNext { enabled in
        self.addLostObjectButton.backgroundColor = enabled ? UIColor.minesAlesColor() : UIColor.lightGrayColor()
    }.bindTo(addLostObjectButton.rx_enabled)
    .addDisposableTo(disposeBag)
    
    addLostObjectButton
      .rx_tap
      .asDriver()
      .driveNext {
        self.view.endEditing(true)
        
        if var lostObject = self.lostObject {
          lostObject.title = self.lostObjectTitleTextField.text!
          lostObject.description = self.lostObjectDescriptionTextView.text
          lostObject.location = self.locationTextField.text!.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          lostObject.found = self.lostObjectFoundSegmentedControl.selectedSegmentIndex == 0
          self.delegate?.updateLostObjectViewController(self, didFinishWithUpdatedLostObject: lostObject)
          
        } else {
          self.delegate?.addLostObjectViewController(self, didFinishWithTitle: self.lostObjectTitleTextField.text!,
            description: self.lostObjectDescriptionTextView.text!, found: self.lostObjectFoundSegmentedControl.selectedSegmentIndex == 0, location: self.locationTextField.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))
        }
        
      }.addDisposableTo(disposeBag)
  }
}


// MARK: - UIKeyboard Notification -

extension AddUpdateLostObjectViewController: UITextFieldDelegate {
  
  func keyboardWillShow(notification: NSNotification) {
      let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.0, options: .CurveLinear,
                                 animations: { self.keyboardBarViewConstraint.constant = keyboardHeight ; self.view.layoutIfNeeded()}, completion: nil)
    }
}
