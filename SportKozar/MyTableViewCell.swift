//
//  MyTableViewCell.swift
//  SportKozar
//
//  Created by Raman Kozar on 28/08/2022.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    //  Adding a Label
    @IBOutlet weak var myLabel: UILabel!
    
    //  Adding an ID for synchronization. To fill in the Identifier field in the Table View Cell
    static let id = "MyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
