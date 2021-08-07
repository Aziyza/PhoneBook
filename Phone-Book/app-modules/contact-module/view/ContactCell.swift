//
//  ContactCell.swift
//  Phone-Book
//
//  Created by Mac on 8/6/21.
//

import UIKit

class ContactCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(model: ContactModel) {
        self.name.text = model.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
    
}
