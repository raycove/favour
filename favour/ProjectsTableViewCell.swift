//
//  ProjectsTableViewCell.swift
//  favour
//
//  Created by Ray Cove on 22/01/2018.
//  Copyright © 2018 Ray Cove. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet var projectstitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var tableviewcellbackground: PrettyView!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
