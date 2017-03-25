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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let detailsVC = segue.destination as? PersonDetailViewController else { return }
        detailsVC.idEndpoint = "\(APIRequestManager.peopleEndpoint)/\(people[indexPath.row].id)"
    }

}
