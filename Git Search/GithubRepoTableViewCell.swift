//
//  GithubRepoTableViewCell.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit

class GithubRepoTableViewCell: UITableViewCell {
    
    // Labels for displaying data on the storyboard/views
    @IBOutlet weak var repoNameLabel: UILabel!
    
    @IBOutlet weak var repoStarsLabel: UILabel!
    
    @IBOutlet weak var repoForksLabel: UILabel!
    
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoOwnerLabel: UILabel!
    
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var repoOwnerAvatarImageView: UIImageView!
    
    @IBOutlet weak var forkImageView: UIImageView!
    var repo: GithubRepo? {
        didSet {
            // set the values of the labels/images
            repoNameLabel.text = repo?.name
            if let stars = repo?.stars {
                repoStarsLabel.text = "\(stars)"
            }
            if let forks = repo?.forks {
                repoForksLabel.text = "\(forks)"
            }
            repoOwnerLabel.text = repo?.ownerHandle
            repoDescriptionLabel.text = repo?.repoDescription
            
            if let ownerAvatarURL = URL(string: (repo?.ownerAvatarURL)!) {
                self.repoOwnerAvatarImageView.setImageWith(ownerAvatarURL)
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
