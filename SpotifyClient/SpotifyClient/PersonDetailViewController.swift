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
            guard let endpoint = idEndpoint else { return }
            APIRequestManager.shared.getData(endpoint: endpoint) { (data) in
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
            self.title = person.id
            nameTextField.text = person.name
            favoriteCityTextField.text = person.favoriteCity
            
            nameTextField.borderStyle = .none
            favoriteCityTextField.borderStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let idEndpoint = idEndpoint {
            print(idEndpoint)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        editButton.isHidden = false
        
        nameTextField.isUserInteractionEnabled = false
        nameTextField.borderStyle = .none
        
        favoriteCityTextField.isUserInteractionEnabled = false
        favoriteCityTextField.borderStyle = .none
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        editButton.isHidden = true
        
        nameTextField.isUserInteractionEnabled = true
        nameTextField.borderStyle = .roundedRect
        
        favoriteCityTextField.isUserInteractionEnabled = true
        favoriteCityTextField.borderStyle = .roundedRect
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
