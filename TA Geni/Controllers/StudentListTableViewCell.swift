//
//  StudentListTableViewCell.swift
//  TA Geni
//
//  Created by John Young on 2/27/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import RealmSwift

class StudentListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
