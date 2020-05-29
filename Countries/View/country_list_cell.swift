//
//  country_list_cell.swift
//  Countries
//
//  Created by Amit Saxena on 29/05/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit

class country_list_cell: UITableViewCell {

    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var img_flag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
