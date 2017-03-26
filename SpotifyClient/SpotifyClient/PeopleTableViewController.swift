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
    
    var filteredPeople = [Person]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchActive = false
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
//        print("search button clicked")
//        dismissKeyboard()
//        guard let id = searchIDBar.text, id != "" else {
//            if self.people.count == 0 {
//                self.loadPeople()
//            }
//            return }
//        print("\(APIRequestManager.peopleEndpoint)/\(id)")
//        APIRequestManager.shared.makeRequest(ofType: .get, endpoint: "\(APIRequestManager.peopleEndpoint)/\(id)", with: nil) { (data) in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                if let person = Person.getPerson(from: data) {
//                    self.people = [person]
//                }
//            }
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPeople = people.filter({ (person) -> Bool in
            let idNSString = person.id as NSString
            let nameNSString = person.name as NSString
            let cityNSString = person.favoriteCity as NSString
            
            let idRange = idNSString.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let nameRange = nameNSString.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let cityRange = cityNSString.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return idRange.location != NSNotFound || nameRange.location != NSNotFound || cityRange.location != NSNotFound
        })
        if(filteredPeople.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchIDBar.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredPeople.count
        }
        return people.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCellIdentifier", for: indexPath)
        var person = people[indexPath.row]
        
        if searchActive {
            person = filteredPeople[indexPath.row]
        }
        
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = "\(person.favoriteCity), ID: \(person.id)"
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
        if searchActive{
            detailsVC.idEndpoint = "\(APIRequestManager.peopleEndpoint)/\(filteredPeople[indexPath.row].id)"
        } else {
            detailsVC.idEndpoint = "\(APIRequestManager.peopleEndpoint)/\(people[indexPath.row].id)"
        }
    }

}
