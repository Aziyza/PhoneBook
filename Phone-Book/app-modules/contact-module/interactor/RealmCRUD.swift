//
//  RealmCRUD.swift
//  Phone-Book
//
//  Created by Mac on 8/7/21.
//

import Foundation
import RealmSwift

class RealmCRUD {
    
    let realm = try! Realm()
    
    //MARK: - Realm CRUD Methods
    func addData(contact: ContactModel) {
        do {
            try realm.write {
                realm.add(contact)
        }
        } catch {
            print("Realm Error while create: \(error.localizedDescription)")
        }
    }
    
    func loadData(with predicate: NSPredicate? = nil) -> Results<ContactModel> {
        if predicate != nil {
            return realm.objects(ContactModel.self).filter(predicate!)
        } else {
            return realm.objects(ContactModel.self).sorted(byKeyPath: "name", ascending: true)
        }
                
    }
    
    func updateData(oldContact: ContactModel, newContact: ContactModel) {
        do {
            try realm.write() {
                oldContact.name = newContact.name
                oldContact.phone = newContact.phone
            }
        } catch {
            print("Realm Error while update: \(error)")
        }
    }
    
    func deleteData(contact: ContactModel) {
        do {
            try realm.write {
                realm.delete(contact)
        }
        } catch {
            print("Realm Error while create: \(error.localizedDescription)")
        }
    }
}
