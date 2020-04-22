//
//  CommonTableViewCell.swift
//  UnityCar
//
//  Created by lax on 2019/10/18.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell {
        
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var headImageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var arrowImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(model: CellModel) {
        titleLabel.text = model.title
        titleLabel.textColor = model.titleColor ?? .darkText
        detailLabel.text = model.detail
        detailLabel.textColor = model.detailColor ?? .darkGray
        if let image = model.icon {
            headImageView.image = image
            headImageViewWidth.constant = 30
        } else {
            headImageView.image = nil
            headImageViewWidth.constant = 0
        }
        if let image = model.image {
            detailImageView.image = image
            detailImageView.isHidden = false
        } else {
            detailImageView.image = nil
            detailImageView.isHidden = true
        }
        if let arrow = model.arrow, arrow == true {
            arrowImageView.isHidden = false
        } else {
            arrowImageView.isHidden = true
        }
        if let autoArrowWidth = model.autoArrowWidth, autoArrowWidth == true {
            if let arrow = model.arrow, arrow == true {
                arrowImageWidth.constant = 16
            } else {
                arrowImageWidth.constant = 0
            }
        } else {
            arrowImageWidth.constant = 16
        }
    }
    
}
