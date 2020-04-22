//
//  PaddingTableViewCell.swift
//  UnityCar
//
//  Created by lax on 2019/11/4.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class PaddingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
