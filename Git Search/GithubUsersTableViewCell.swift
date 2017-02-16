//
//  GithubUsersTableViewCell.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit

class GithubUsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userLocationLabel: UILabel!
    
    @IBOutlet weak var userClockLabel: UILabel!
    
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var userOwnerAvatarImageView: UIImageView!
    
    @IBOutlet weak var clockImageView: UIImageView!
    
    var user: GithubUsers? {
        didSet {
            // set the values of the labels/images
            if let userLocation = user?.userLocation {
                userLocationLabel.text = "\(userLocation)"
            }
            if let createdAt = user?.createdAt {
                userClockLabel.text = "\(createdAt)"
            }
            userNameLabel.text = user?.ownerHandle
            userDescriptionLabel.text = user?.userBio
            
            if let ownerAvatarURL = URL(string: (user?.ownerAvatarURL)!) {
                self.userOwnerAvatarImageView.setImageWith(ownerAvatarURL)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
