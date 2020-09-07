//
//  ProfileHeaderCollectionViewCell.swift
//  favour
//
//  Created by Ray Cove on 04/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileimage: UIImageView!
    
    @IBOutlet weak var profilenamelabel: UILabel!
    
    @IBOutlet weak var profilelocationlabel: UILabel!
    @IBOutlet weak var profilebiolabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
