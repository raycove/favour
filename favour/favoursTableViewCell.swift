//
//  favoursTableViewCell.swift
//  favour
//
//  Created by Ray Cove on 30/09/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

class favoursTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var tabletext: UILabel!
    @IBOutlet weak var tablelabel: UILabel!
    @IBOutlet var viewcount: UILabel!
    
    @IBOutlet var favourdate: UILabel!
    
    @IBOutlet var applicationscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
