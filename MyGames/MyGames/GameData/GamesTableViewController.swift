//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by zupper on 11/01/20.
//  Copyright © 2020 zupper. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    var fetchResultController : NSFetchedResultsController<Game>!
    
    var label = UILabel()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier! == "gameSegue"{
                let vc = segue.destination as! GameViewController
                if let games = fetchResultController.fetchedObjects{
                    vc.game = games[tableView.indexPathForSelectedRow!.row]
                }
            }
        }
        
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        
        
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.barTintColor = .white
            searchController.searchBar.tintColor = .white
        
        
         loadGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        tableView.reloadData()
    }
    
    
    func loadGames(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        if !filtering.isEmpty{
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do{
            try fetchResultController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
        
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        // #warning Incomplete implementation, return the number of rows
        
       let count = fetchResultController.fetchedObjects!.count ?? 0
        
        tableView.backgroundView = count == 0 ? label: nil
        
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else{
            return cell
        }
        
        cell.prepare(with: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchResultController.fetchedObjects?[indexPath.row] else{ return }
                context.delete(game)
            }
            
        }
    }

extension GamesTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}


extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
}
