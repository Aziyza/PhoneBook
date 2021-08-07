//
//  ContactsVC.swift
//  Phone-Book
//
//  Created by Mac on 8/6/21.
//

import UIKit
import RealmSwift

class ContactsVC: UIViewController {
    
    let realmCRUD = RealmCRUD()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
            tableView.tableFooterView = UIView()
        }
    }
    
    var data: Results<ContactModel>?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        DispatchQueue.main.async {
            self.data = self.realmCRUD.loadData()
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add new contact", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameText) in
            nameText.placeholder = "Name"
            
        }
        alert.addTextField { (phoneText) in
            phoneText.placeholder = "Phone number"
            phoneText.keyboardType = .phonePad
        }
        let okAction = UIAlertAction(title: "Add", style: .default) { [self] (UIAlertAction) in
            
            let newContact = ContactModel()
            newContact.name = alert.textFields![0].text
            newContact.phone = alert.textFields![1].text
            realmCRUD.addData(contact: newContact)
            tableView.reloadSections([0], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


//MARK: - UITableView Configuration
extension ContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        cell.configure(model: data![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // right swipe actions (delete, edit)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (_, _, _) in
            realmCRUD.deleteData(contact: data![indexPath.row])
            tableView.reloadSections([0], with: .automatic)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let alert = UIAlertController(title: "Edit contact", message: nil, preferredStyle: .alert)
            alert.addTextField { [self] (nameText) in
                nameText.text = data?[indexPath.row].name
                nameText.placeholder = "Name"
            }
            alert.addTextField { [self] (phoneText) in
                phoneText.text = data?[indexPath.row].phone
                phoneText.keyboardType = .phonePad
                phoneText.placeholder = "Phone number"
            }
            
            let editAction = UIAlertAction(title: "Edit", style: .default) { [self] (UIAlertAction) in
                
                let newContact = ContactModel()
                newContact.name = alert.textFields![0].text
                newContact.phone = alert.textFields![1].text
                realmCRUD.updateData(oldContact: data![indexPath.row], newContact: newContact)
                tableView.reloadSections([0], with: .automatic)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(editAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContactDetailVC(nibName: "ContactDetailVC", bundle: nil)
        vc.nameText = data![indexPath.row].name
        vc.phoneText = data![indexPath.row].phone
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UISearchBar Delegate methods
extension ContactsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text!.isEmpty {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchController.searchBar.text!)
            data = realmCRUD.loadData(with: predicate)
            tableView.reloadSections([0], with: .automatic)
        } else {
            data = realmCRUD.loadData()
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
}
