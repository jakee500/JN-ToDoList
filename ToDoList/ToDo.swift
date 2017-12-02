import Foundation
import UIKit

class ToDo: NSObject, NSCoding {
    
    var title: String
    var isComplete: Bool
    var notes: String?
    var photoTaken: UIImage? = nil

    
    
    
    // This can be reused to set date properties and an instance can be made in your VC.
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    struct PropertyKeys {
        static let title = "title"
        static let isComplete = "isComplete"
        static let notes = "notes"
        
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivedURL = DocumentsDirectory.appendingPathComponent("todosInstance")
    
    static func loadToDos() -> [ToDo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDo.ArchivedURL.path) as? [ToDo]
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        NSKeyedArchiver.archiveRootObject(todos, toFile: ToDo.ArchivedURL.path)
    }
    
    static func loadSampleToDoList() -> [ToDo] {
        let toDo1 = ToDo(title: "monkey", isComplete: false, notes: "bear")
        let toDo2 = ToDo(title: "chimp", isComplete: false, notes: "bear")
        let toDo3 = ToDo(title: "snake", isComplete: false, notes: "bear")
        
        

        return [toDo1, toDo2, toDo3]
    }
    
    init(title: String, isComplete: Bool, notes: String) {
        // below stops you having a empty title
        guard !title.isEmpty else {
            fatalError("Reminder requires title")
        }
        
        self.title = title
        self.isComplete = isComplete
        self.notes = notes
    }
    
   
    
    func encode(with aCoder: NSCoder) {
            aCoder.encode(title, forKey: PropertyKeys.title)
            aCoder.encode(isComplete, forKey: PropertyKeys.isComplete)
    
            aCoder.encode(notes, forKey: PropertyKeys.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKeys.title) as? String else {return nil}
        
        let isComplete = aDecoder.decodeBool(forKey: PropertyKeys.isComplete)
        let notes = aDecoder.decodeObject(forKey: PropertyKeys.notes) as? String
        
        self.init(title: title, isComplete: isComplete, notes: notes!)
    }
 
}
