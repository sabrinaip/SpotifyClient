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
    @IBOutlet weak var cityTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!

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
            inEditMode = false
        }
    }
    
    var inEditMode: Bool? {
        didSet {
            guard let inEditMode = inEditMode else { return }
            if inEditMode {
                editButton.isHidden = true
                nameTextField.isUserInteractionEnabled = true
                nameTextField.borderStyle = .roundedRect
                favoriteCityTextField.isUserInteractionEnabled = true
                favoriteCityTextField.borderStyle = .roundedRect
            } else {
                editButton.isHidden = false
                nameTextField.isUserInteractionEnabled = false
                nameTextField.borderStyle = .none
                favoriteCityTextField.isUserInteractionEnabled = false
                favoriteCityTextField.borderStyle = .none
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if idEndpoint != nil {
            inEditMode = false
        } else {
            inEditMode = true
            nameTextField.text = "Sean"
            favoriteCityTextField.text = "New York"
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
            else {
                errorLabel.isHidden = false
                return }
        
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
        inEditMode = false
        
//        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        inEditMode = true
    }
    
    // MARK: - TextField Delegate and keyboard functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLabel.isHidden = true
        if favoriteCityTextField.text == "New York" {
            favoriteCityTextField.text = "Brooklyn"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.errorLabel.isHidden = true
        return true
    }
    
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
            
            if favoriteCityTextField.frame.maxY > self.view.frame.height - keyboardSize.height {

            cityTextFieldBottomConstraint.isActive = false
            cityTextFieldBottomConstraint = favoriteCityTextField.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -keyboardHeight)
            cityTextFieldBottomConstraint.isActive = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        cityTextFieldBottomConstraint.isActive = false
        cityTextFieldBottomConstraint = favoriteCityTextField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
        cityTextFieldBottomConstraint.isActive = true
    }

    
}
