//
//  TableViewController.swift
//  AssignmentTwo
//
//  Created by admin on 26.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var photos = [Photo]()
    
    // SEARCH STUFF
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        clearView()
        searchPhotos()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearView()
    }
    
    private func clearView() {
        photos.removeAll()
        tableView.reloadData()
    }
    
    private func searchPhotos() {
        NetworkManager.shared.requestPhotos(with: (searchBar?.text)!) { (response, error) in
            if let photos = response?.objects {
                var index: Int = 0
                for photo in photos {
                    self.photos.insert(photo, at: index)
                    index += 1
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // SET THOSE DELEGATES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    // TABLE VIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleResultCell", for: indexPath)
        
        let photo: Photo = photos[indexPath.row]
        
        if let cell = cell as? ResultTableViewCell {
            cell.displayTitle = photo.title
            cell.pictureID = photo.identifier
        }
        
        return cell
    }
    
    // SEGUEING
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showPictureLocation":
                if let cell = sender as? ResultTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToMVC = segue.destination as? LocationViewController {
                    seguedToMVC.pictureID = cell.pictureID
                }
                
            default: break
            }
        }
    }
    
    // STUFF
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
