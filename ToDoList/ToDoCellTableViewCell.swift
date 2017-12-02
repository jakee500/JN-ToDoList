import UIKit

@objc protocol ToDoCellDelegate: class {
    func checkmarkPressed(sender: ToDoCellTableViewCell)
}

class ToDoCellTableViewCell: UITableViewCell {
    
    // Mark: - Var
    var delegate: ToDoCellDelegate?
    
    @IBOutlet weak var isCompleteButtonOutlet: UIButton!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    
    // Mark: - Actions
    
    @IBAction func completeButtonPressed() {
        
        delegate?.checkmarkPressed(sender: self)
        print("button pressed")
    }
    
    

}
