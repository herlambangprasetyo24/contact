//
//  Contact.swift
//  Contact Jenius
//
//  Created by Herlambang Prasetyo on 10/16/18.
//  Copyright © 2018 Herlambang Prasetyo. All rights reserved.
//

import UIKit

struct Contact {
    let id:String
    let firstName:String
    let lastName:String
    let age:Int
    let photo: String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let id = json["id"] as? String else {throw SerializationError.missing("id is missing")}
        
        guard let firstName = json["firstName"] as? String else {throw SerializationError.missing("firstName is missing")}
        
        guard let lastName = json["lastName"] as? String else {throw SerializationError.missing("lastName is missing")}
        
        guard let age = json["age"] as? Int else {throw SerializationError.missing("age is missing")}
        guard let photo = json["photo"] as? String else {throw SerializationError.missing("photo is missing")}
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.photo = photo
        
    }
    
    static let basePath = "http://simple-contact-crud.herokuapp.com/"
    
    static func getContact(completion: @escaping ([Contact]?) -> ()) {
        
        let url = basePath + "contact"
        print(url)
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var contactArray:[Contact] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let contactsData = json["data"] as? [[String:Any]] {
                            for contact in contactsData {
                                if let contactObject = try? Contact(json: contact) {
                                    contactArray.append(contactObject)
                                }
                            }
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(contactArray)
            }
        }
        task.resume()
    }
    
    static func deleteContact(id: String, completion: @escaping (String) -> ()) {
        
        let url = basePath + "contact/\(id)"
        print(url)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var responseString: String = ""
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let message = json["message"] as? String {
                            responseString = message
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(responseString)
            }
        }
        task.resume()
    }
    
    static func createContact(id: String, method: String, data: [String:Any], completion: @escaping (String) -> ()) {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
            var url = basePath + "contact"
            if method == "PUT" {
                url = "\(url)/\(id)"
            }
            print(url)
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = method
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                
                var responseString: String = ""
                
                if let data = data {
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                            if let message = json["message"] as? String {
                                responseString = message
                            }
                            
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        completion(responseString)
                    }
                }
            }
            task.resume()
        }
    }
}
