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
    @IBOutlet weak var nameEditButton: UIButton!
    @IBOutlet weak var favoriteCityEditButton: UIButton!
    @IBOutlet weak var favoriteCityBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func nameEditButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func favoriteCityButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    
}
