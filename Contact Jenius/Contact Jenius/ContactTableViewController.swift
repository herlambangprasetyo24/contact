//
//  ContactTableViewController.swift
//  Contact Jenius
//
//  Created by Herlambang Prasetyo on 10/17/18.
//  Copyright © 2018 Herlambang Prasetyo. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController, ContactTableViewCellInterface {
    
    var contactData = [Contact]()
    var selectedEditContact: Contact!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContactList()
    }
    
    func getContactList() {
        Contact.getContact { (results:[Contact]?) in
            if let contacts = results {
                self.contactData = contacts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return contactData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        let data = contactData[indexPath.section]
        cell.id = data.id
        cell.contactName.text = "\(data.firstName) \(data.lastName)"
        cell.contactAge.text = "\(data.age) Years"
        cell.contactImage.image = downloadImage(from: data.photo)
        cell.setInterface(self)
        
        // Configure the cell
        
        return cell
    }
    
    func onEditContact(id: String) {
        for contact in contactData {
            if contact.id == id {
                selectedEditContact = contact
                break
            }
        }
        
        goToEditPage()
    }
    
    func onDeletedContact(id: String) {
        Contact.deleteContact(id: id) { (message: String) in
            if message == "contact deleted" {
                self.getContactList()
            } else {
                self.showAlert(message: message)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: false, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    func downloadImage(from urlString: String) -> UIImage {
        do {
            let url = URL(string: urlString)
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        }
        catch{
            print(error)
            return UIImage(named: "defaultImage")!
        }
    }

    func goToEditPage() {
        let page = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEditContact") as! AddEditContact
        page.selectedData = selectedEditContact
        page.title = selectedEditContact == nil ? "Add Contact" : "Edit Contact"
        self.navigationController?.pushViewController(page, animated: true)
    }
    
    @IBAction func addNewContact(_ sender: Any) {
        selectedEditContact = nil
        goToEditPage()
    }
}
