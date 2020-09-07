//
//  ProfileHeaderCollectionReusableView.swift
//  favour
//
//  Created by Ray Cove on 04/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView, UICollectionViewDelegate {



    @IBOutlet var topview: UIView!
    
    @IBOutlet var profilebio: UITextView!
    
    
    @IBOutlet weak var profileimage: UIImageView!
    
    @IBOutlet weak var profilename: UILabel!


    @IBOutlet weak var profilelocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
