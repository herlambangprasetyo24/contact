//
//  ContactTableViewCell.swift
//  Contact Jenius
//
//  Created by Herlambang Prasetyo on 10/17/18.
//  Copyright © 2018 Herlambang Prasetyo. All rights reserved.
//

import UIKit

public protocol ContactTableViewCellInterface {
    func onEditContact(id: String)
    func onDeletedContact(id: String)
}

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactAge: UILabel!
    
    var interface: ContactTableViewCellInterface!
    var id: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setInterface(_ interface: ContactTableViewCellInterface) {
        self.interface = interface
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onEditContact(_ sender: Any) {
        interface.onEditContact(id: self.id)
    }
    
    @IBAction func onDeletedContact(_ sender: Any) {
        interface.onDeletedContact(id: self.id)
    }
}
