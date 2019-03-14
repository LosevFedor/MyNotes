//
//  AllNotesTableViewCell.swift
//  MyNotes
//
//  Created by admin on 14.01.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AllNotesTableViewCell: UITableViewCell {


    @IBOutlet var imageNote: UIImageView!
    @IBOutlet var textNote: UILabel!
    @IBOutlet var labelRemindNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

    
}
