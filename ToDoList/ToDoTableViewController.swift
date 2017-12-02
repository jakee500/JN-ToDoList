//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Jake Noble on 17/11/2017.
//  Copyright © 2017 Jake Noble. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    // below is needed to manage a collection of items
    var todosInstance = [ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This enables the the edit button enabling editing mode.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedToDos = ToDo.loadToDos() {
            todosInstance = savedToDos
        } else {
            todosInstance = ToDo.loadSampleToDoList()
        }
    }

    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todosInstance.count
    }

    
    
    
    
    // this method is called whenever a cell is about to be dispayed onscreen. It also provides you wit indexPath. IndexPath determines which cell you are dealing with.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    // Below the following happens: Attempt to dequeue a cell - fail if unsuccessful. Get the model out of the array that corresponds to the cell being displayed. Update the cell's properties appropriately, and return the cell from the method.
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCellTableViewCell else {
            fatalError("Cell not dequeued")
            
        }
        
        // delegate is accesible through the delegate.
        cell.delegate = self
        
        let todo = todosInstance[indexPath.row]
        cell.titleLabelOutlet?.text = todo.title
        cell.isCompleteButtonOutlet.isSelected = todo.isComplete
        return cell

    }
   

    
    // This puts it into editing mode.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // This lets you swipe and delete table items.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todosInstance.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todosInstance)
        }    
    }
    

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
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        // This isn't your typical segue as this is passing back the other way via an unwind. However the pronicple is the same.
        // Verify the correct segue is being called.
        guard segue.identifier == "saveUnwind" else {return}
        
        // Define the location in a constant ie sourceViewControler
        let sourceViewController = segue.source as! NewToDoTableViewController
        
        // This is grabbing todo from NewToDoTableViewController
        if let todo = sourceViewController.todo {
          
            
// This was in place for the unwind segue but this meant when edited, a new version apperaed in the todo list. Therefore I have commented this out and put new if let syntax so that if it has a value then append else create a new item.
            
//            // This makes a new todo item be put on the bottom of the list as it is after todosInstance.count ie last.
//            let newIndexPath = IndexPath(row: todosInstance.count, section: 0)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todosInstance[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todosInstance.count, section: 0)
              
            
            
            // This appends todo from NewToDoTableViewController and then inserts in the new location. The last bit .automatice is the animation style for adding the item.
            todosInstance.append(todo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        ToDo.saveToDos(todosInstance)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let newToDoViewController = segue.destination as! NewToDoTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedToDo = todosInstance[indexPath.row]
            newToDoViewController.todo = selectedToDo
        }
    }
    
    // Method from protocol
    func checkmarkPressed(sender: ToDoCellTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let todo = todosInstance[indexPath.row]
            todo.isComplete = !todo.isComplete
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todosInstance)
        }
        
    }
}

    


