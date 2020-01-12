//
//  ConsoleManager.swift
//  MyGames
//
//  Created by zupper on 12/01/20.
//  Copyright © 2020 zupper. All rights reserved.
//

import Foundation
import CoreData

class ConsoleManager{
    
    static let shared = ConsoleManager()
    var consoles: [Console] = []
    
    func loadConsole(with context: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortFescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortFescriptor]
        
        do {
            consoles = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext){
        let console = consoles[index]
        context.delete(console)
        
        do {
            try context.save()
            consoles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private init(){
        
    }
}
