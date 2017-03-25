//
//  PeopleTableViewController.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchIDBar: UISearchBar!
    
    var people = [Person]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPeople()
    }
    
    // MARK: - Helper functions
    
    func loadPeople() {
        
        APIRequestManager.shared.makeRequest(ofType: .get, endpoint: APIRequestManager.peopleEndpoint, with: nil) { (data) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.people = Person.getAllPeople(from: data)
            }
        }
    }
    
    // MARK: - SearchBarDelegate and keyboard functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        guard let id = searchIDBar.text, id != "" else {
            if self.people.count == 0 {
                self.loadPeople()
            }
            return true }
        APIRequestManager.shared.makeRequest(ofType: .get, endpoint: "\(APIRequestManager.peopleEndpoint)/\(id)", with: nil) { (data) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let person = Person.getPerson(from: data) {
                    self.people = [person]
                }
            }
        }
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCellIdentifier", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = "\(person.favoriteCity)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let idEndpoint = "\(APIRequestManager.peopleEndpoint)/\(people[indexPath.row].id)"
        
        APIRequestManager.shared.makeRequest(ofType: .delete, endpoint: idEndpoint, with: nil) { (data) in
            self.loadPeople()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let detailsVC = segue.destination as? PersonDetailViewController else { return }
        detailsVC.idEndpoint = "\(APIRequestManager.peopleEndpoint)/\(people[indexPath.row].id)"
    }

}
