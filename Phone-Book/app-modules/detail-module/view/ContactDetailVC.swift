//
//  ContactDetailVC.swift
//  Phone-Book
//
//  Created by Mac on 8/7/21.
//

import UIKit

class ContactDetailVC: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    var nameText: String?
    var phoneText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = nameText
        phone.text = phoneText
        
    }

    @IBAction func callTapped(_ sender: UIButton) {
        
        let call = phone.text ?? ""
        guard let number = URL(string: "tel://" + call) else { return }
        UIApplication.shared.open(number)
        
    }
}
