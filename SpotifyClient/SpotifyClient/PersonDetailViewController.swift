//
//  PersonDetailViewController.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var favoriteCityTextField: UITextField!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editButtonTopConstraint: NSLayoutConstraint!

    var idEndpoint: String? {
        didSet {
            guard let idEndpoint = idEndpoint else { return }
            
            APIRequestManager.shared.makeRequest(ofType: .get, endpoint: idEndpoint, with: nil) { (data) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.person = Person.getPerson(from: data)
                }
            }
        }
    }

    var person: Person? {
        didSet {
            guard let person = person else { return }
            self.title = String(person.id)
            nameTextField.text = person.name
            favoriteCityTextField.text = person.favoriteCity
            disableEditting()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let idEndpoint = idEndpoint {
            print(idEndpoint)
        } else {
            enableEditting()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
            name != "",
            let city = favoriteCityTextField.text,
            city != ""
            else { return }
        
        let jsonObject = [
            "name" : name,
            "favoriteCity" : city
        ]
        
        if let idEndpoint = idEndpoint {
            APIRequestManager.shared.makeRequest(ofType: .put, endpoint: idEndpoint, with: jsonObject, completion: { (data) in
                // TO DO : MAKE POPUP
                print("put")
            })
        } else {
            APIRequestManager.shared.makeRequest(ofType: .post, endpoint: APIRequestManager.peopleEndpoint, with: jsonObject, completion: { (data) in
                // TO DO : MAKE POPUP
                print("posted")
            })
        }
        disableEditting()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        enableEditting()
    }
    
    // MARK: - Helper functions
    
    func enableEditting() {
        editButton.isHidden = true
        
        nameTextField.isUserInteractionEnabled = true
        nameTextField.borderStyle = .roundedRect
        
        favoriteCityTextField.isUserInteractionEnabled = true
        favoriteCityTextField.borderStyle = .roundedRect
    }
    
    func disableEditting() {
        editButton.isHidden = false
        
        nameTextField.isUserInteractionEnabled = false
        nameTextField.borderStyle = .none
        
        favoriteCityTextField.isUserInteractionEnabled = false
        favoriteCityTextField.borderStyle = .none
    }
    
    // MARK: - TextField Delegate and keyboard functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            if editButton.frame.minY > self.view.frame.height - keyboardSize.height {

            editButtonTopConstraint.isActive = false
            editButtonTopConstraint = editButton.topAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -keyboardHeight)
            editButtonTopConstraint.isActive = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        editButtonTopConstraint.isActive = false
        editButtonTopConstraint = editButton.topAnchor.constraint(equalTo: self.view.centerYAnchor)
        editButtonTopConstraint.isActive = true
    }

    
}
