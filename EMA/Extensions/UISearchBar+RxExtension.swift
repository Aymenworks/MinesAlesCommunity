//
//  UISearchBar+RxExtension.swift
//  EMA
//
//  Created by Rebouh Aymen on 27/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension UISearchBar {
  #if os(iOS)
  public var rx_searchBarBeginEditing: ControlEvent<Void> {
    let source: Observable<Void> = rx_delegate.observe(#selector(UISearchBarDelegate.searchBarTextDidBeginEditing(_:)))
      .map { _ in
        return ()
    }
    return ControlEvent(events: source)
  }
  #endif
}