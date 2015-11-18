//
//  EditProfileViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/17.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit
import Eureka

class EditProfileViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum Category : String, CustomStringConvertible {
        case Art = "Art"
        case Cars_and_motorcycles = "Cars and motorcycles"
        case Cooking = "Cooking"
        case Design = "Design"
        case DIY_and_crafts = "DIY_and_crafts"
        case Film = "Film"
        case Health = "Health"
        case Music = "Music"
        case Photography = "Photography"
        case Sports = "Sports"
        
        var description : String { return rawValue }
        
        static let allValues = [Art, Cars_and_motorcycles, Cooking, Design, DIY_and_crafts, Film, Health, Music, Photography, Sports]
    }
    
    private func initializeForm() {
        let font = UIFont(name: "Avenir-Medium", size: 16.0)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        NameRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        PickerInlineRow<Category>.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        TextAreaRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        form =
            
            Section("Basic")
        
            <<< NameRow("First"){
                $0.title =  "First Name"
                $0.cell.textField.placeholder = "Leo"
            }
        
            <<< NameRow("Last"){
                $0.title =  "Last Name"
                $0.cell.textField.placeholder = "Luo"
            }

            <<< EmailRow("Email"){
                $0.title =  "Email"
                $0.cell.textField.placeholder = "leoluo@gmail.com"
            }
            
            <<< PasswordRow("Password"){
                $0.title =  "Password"
            }
        
            +++ Section("Image")
                
            <<< ImageRow("Profile"){
                $0.title = "Profile"
            }
            <<< ImageRow("Background"){
                $0.title = "Backgorund"
            }
            
            +++ Section("Interest 1")
            
            <<< TextRow("TagOne"){
                $0.title = "Tag"
                $0.cell.textField.placeholder = "one"
            }
            
            <<< PickerInlineRow<Category>("CategoryOne") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
            }
            
            +++ Section("Interest 2")
            
            <<< TextRow("TagTwo"){
                $0.title = "Tag"
                $0.cell.textField.placeholder = "two"
            }
            
            <<< PickerInlineRow<Category>("CategoryTwo") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
            }
            
            +++ Section("Interest 3")
            
            <<< TextRow("TagThree"){
                $0.title = "Tag"
                $0.cell.textField.placeholder = "three"
            }
            
            <<< PickerInlineRow<Category>("CategoryThree") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
            }

            +++ Section("Intro")
            
            <<< TextAreaRow("Intro") {
                $0.placeholder = "I am Leo!!!!!!!"
                $0.cell.textView.font = font
            }
    }
    

    func validate(fields: [String: Any?]) -> String? {
        if fields["First"] as? String == nil {
            return "First name can't be empty!"
        }
        if fields["Last"] as? String == nil {
            return "Last name can't be empty!"
        }
        if fields["Email"] as? String == nil {
            return "Email can't be empty!"
        }
        if fields["Password"] as? String == nil {
            return "Password can't be empty!"
        }
        if fields["Intro"] as? String == nil {
            return "Intro can't be empty!"
        }
        if fields["Profile"] as? UIImage == nil {
            return "Profile can't be empty!"
        }
        if fields["Background"] as? UIImage == nil {
            return "Background can't be empty!"
        }
        return nil
    }
    
    func alertHandler(alert: UIAlertAction!) -> Void {
        performSegueWithIdentifier("unwindToProfileTab", sender: self)
    }
    
    func createAlert(message: String, unwind: Bool) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: unwind ? alertHandler : nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func editProfile(sender: UIBarButtonItem) {
        // let session = Session()
        let values = self.form.values()
        let errorMsg = validate(values)
        if errorMsg == nil {
            if let currentUser = User.currentUser() {
                User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        if let user = object as? User {
                            // update user
                            user.firstname = values["First"] as! String
                            user.lastname = values["Last"] as! String
                            user.password = values["Password"] as? String
                            user.email = values["Email"] as? String
                            user.intro = values["Intro"] as? String
                            // TODO: save user's interest;
                            let profile = UIImageJPEGRepresentation(values["Profile"] as! UIImage, 0.5)
                            user.profileImage = PFFile(name: "profile.jpg", data: profile!)!
                            let background = UIImageJPEGRepresentation(values["Background"] as! UIImage, 0.5)
                            user.backgroundImage = PFFile(name: "background.jpg", data: background!)!
                            user.saveInBackgroundWithBlock {
                                (succeeded: Bool, error: NSError?) -> Void in
                                if (succeeded) {
                                    self.createAlert("Successfully edited profile", unwind: true)
                                } else {
                                    print("Error updating user")
                                }
                            }
                        }
                    } else {
                        print("Error saving the edited profile")
                    }
                }
            }
        } else {
            createAlert(errorMsg!, unwind: false)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
