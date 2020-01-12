//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by zupper on 11/01/20.
//  Copyright © 2020 zupper. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    var consolesManager = ConsoleManager.shared
    
    @IBOutlet weak var addConso: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
    
    }
    
    func loadConsoles(){
        consolesManager.loadConsole(with: context)
        tableView.reloadData()
        
    }
    
    
    @IBAction func addConsole(_ sender: Any) {
        showAlert(with: nil)
        
    }
    
    func showAlert(with console: Console?){
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + "plataforma", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome da Plataforma"
            if let name = console?.name {
                textField.text = name
            }
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                let console = console ?? Console(context: self.context)
                console.name = alert.textFields?.first?.text
                do{
                    try self.context.save()
                }catch{
                    print(error.localizedDescription)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.view.tintColor = UIColor(named: "second")
            self.present(alert, animated: true, completion: nil )
        }
        
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return consolesManager.consoles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consolesManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name
        
        return cell
    }
}

