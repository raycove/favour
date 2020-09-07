//
//  ProjectsTableViewCell.swift
//  favour
//
//  Created by Ray Cove on 02/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

class ProjectsApplicationTableViewCell: UITableViewCell {

    @IBOutlet var applicationsimage: UIImageView!
    
    @IBOutlet var applicationsname: UILabel!
    
    
    @IBOutlet var applicationviewbutton: PrettyViewButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
