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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPeople()
    }
    
    // MARK: - Helper functions
    
    func loadPeople() {
        APIRequestManager.shared.getRequest(endpoint: APIRequestManager.peopleEndpoint) { (data) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.people = Person.getAllPeople(from: data)
            }
        }
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
        APIRequestManager.shared.deleteRequest(endpoint: idEndpoint) { (data) in
            //tableView.deleteRows(at: [indexPath], with: .fade)
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
