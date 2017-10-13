//
//  CustomTableViewCell.swift
//  MusicMania
//
//  Created by Richa Dua on 22/05/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
