//
//  ARMovieReviewCell.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import UIKit

class ARMovieReviewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reviewCellConfiguration( review: ARReview) {
        authorLabel.text = review.author
        contentLabel.text = review.content
    }
}
