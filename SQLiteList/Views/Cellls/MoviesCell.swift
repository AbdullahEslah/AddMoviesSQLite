//
//  MoviesCell.swift
//  SQLiteList
//
//  Created by Macbook on 29/05/2022.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
