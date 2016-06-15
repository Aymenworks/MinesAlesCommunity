//
//  AdvertisementTableViewCell.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit

class AdvertismentTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var creatorNameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var rightPriceMarginConstraint: NSLayoutConstraint!
}
