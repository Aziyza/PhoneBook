//
//  ContactModel.swift
//  Phone-Book
//
//  Created by Mac on 8/6/21.
//

import Foundation
import RealmSwift

class ContactModel: Object {
   @objc dynamic var name: String?
    @objc dynamic var phone: String?
}
