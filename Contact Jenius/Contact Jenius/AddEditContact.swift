//
//  AddEditContact.swift
//  Contact Jenius
//
//  Created by Herlambang Prasetyo on 10/17/18.
//  Copyright © 2018 Herlambang Prasetyo. All rights reserved.
//

import UIKit

class AddEditContact: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var photoField: UITextField!
    @IBOutlet weak var firstNameInlineError: UILabel!
    @IBOutlet weak var lastNameInlineError: UILabel!
    @IBOutlet weak var ageInlineError: UILabel!
    @IBOutlet weak var photoInlineError: UILabel!
    
    var selectedData: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameInlineError.isHidden = true
        lastNameInlineError.isHidden = true
        ageInlineError.isHidden = true
        photoInlineError.isHidden = true
        
        if selectedData != nil {
            prePopulated()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if validate() {
            let dataDict = ["firstName": firstNameField.text ?? "",
                            "lastName": lastNameField.text ?? "",
                            "age": Int(ageField.text!) ?? 0,
                            "photo": photoField.text ?? ""] as! [String:Any]
            let method = selectedData == nil ? "POST" : "PUT"
            let id = selectedData == nil ? "" : selectedData.id
            Contact.createContact(id: id, method: method, data: dataDict) { (message: String) in
                if message == "contact saved" || message == "Contact edited"{
                    self.showAlert(message: message)
                }
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
    
    func validate() -> Bool {
        let firstNameValid = firstNameField.text != ""
        let lastNameValid = lastNameField.text != ""
        let ageValid = ageField.text != ""
        let photoValid = photoField.text != ""
        
        firstNameInlineError.isHidden = firstNameValid
        lastNameInlineError.isHidden = lastNameValid
        ageInlineError.isHidden = ageValid
        photoInlineError.isHidden = photoValid
        
        return firstNameValid && lastNameValid && ageValid && photoValid
    }
    
    func prePopulated() {
        let age = selectedData?.age
        firstNameField.text = selectedData?.firstName
        lastNameField.text = selectedData?.lastName
        ageField.text = "\(age!)"
        photoField.text = selectedData?.photo
    }
}
