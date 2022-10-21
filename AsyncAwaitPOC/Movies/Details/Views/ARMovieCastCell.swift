//
//  ARMovieCastCell.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import UIKit

class ARMovieCastCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func creditCellConfiguration( cast: ARMovieCast) {
        nameLabel.text = cast.name
        characterLabel.text = "(\(cast.character))"
    }
}
