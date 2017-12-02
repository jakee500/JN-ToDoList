//
//  NewToDoTableViewController.swift
//  ToDoList
//
//  Created by Jake Noble on 20/11/2017.
//  Copyright © 2017 Jake Noble. All rights reserved.
//

import UIKit

class NewToDoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButtonOutlet: UIButton!

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isPickerHidden = true
    
    var todo: ToDo?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This makes sure that when you edit a cell, the items already written are passed back to the static view so you edit.
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButtonOutlet.isSelected = todo.isComplete
            notesTextView.text = todo.notes
        } 
        updateSaveButtonState()
        imagePicker.delegate = self
        
        //Resize image? here
        
        let imageData:NSData = UIImagePNGRepresentation(imagePicker)! as NSData
      
        UserDefaults.standard.set(imageData, forKey: "savedImage")
       
        
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        imageView.image = UIImage(data: data as Data)
        
     
    }
    
    func dogSentance(name: String, col: String, age: Int) -> String {
        return "jake has a dog called \(dave) and he is \(age)and is \(col)"
        
    }
    
    

    // Mark: - Tableview methods
    
    // This changes the height of the cell. But it is not implimented until didselectrow is tapped. See method below.

    //This is used so that when the cell is tapped it expands plus changes the colour of the button
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isPickerHidden = !isPickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
        default: break
        }
    }

    // Mark: - Actions
    
    @IBAction func textEditingChangedFromTextField(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // This is set up so that the return key dismisses the keyboard
    @IBAction func returnedPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
    
    // This enables the button to switch between checked image and unchecked image when the button is pressed.
    @IBAction func isCompleteButtonPressed(_ sender: Any) {
        
        isCompleteButtonOutlet.isSelected = !isCompleteButtonOutlet.isSelected
        
    }
    

    
    
    
    // Mark: - Helper methods
    
    // This method disables the save button if there is no writing in the text field.
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    

    
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButtonOutlet.isSelected
        let notes = notesTextView.text
    
        //todo = ToDo(title: title, isComplete: isComplete, notes: notes!)
        
    }
    @IBAction func loadImage(_ sender: Any) {
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    


}
