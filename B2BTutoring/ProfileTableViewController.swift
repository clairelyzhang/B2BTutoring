//
//  ProfileTableViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/29.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit

class Entry {
    let key : String
    let value : String
    init(k : String, v : String) {
        self.key = k;
        self.value = v;
    }
}

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    var info = [Entry(k: "Loading", v: "Loading")]
    //let profile = Profile()
    let tuteeSession = TuteeSession()
    let tutorSession = TutorSession()
    
    @IBAction func cancelEditProfile(segue: UIStoryboardSegue) {
        print("cancel edit")
    }
    
    @IBAction func completeEditProfile(segue: UIStoryboardSegue) {
        print("complete edit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = User.currentUser() {
            User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        self.nameLabel.text = user.firstname + " " + user.lastname
                        self.info.removeAll()
                        self.info.append(Entry(k: "Name", v: user.firstname + " " + user.lastname))
                        if let email = user.email {
                            self.info.append(Entry(k: "Email:", v: email))
                        }
                        if let phone = user.username {
                            self.info.append(Entry(k: "Phone", v: phone))
                        }
                        if let intro = user.intro {
                            self.info.append(Entry(k: "Info", v: intro))
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error loading user info")
                }
            }
        }
        
        self.tableView.tableHeaderView = self.headerView
        self.navigationItem.rightBarButtonItem?.enabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 1:
            self.headerView.frame = CGRectMake(0,0,0,0)
            self.headerView.hidden = true
            self.tableView.tableHeaderView = self.headerView
            self.navigationItem.rightBarButtonItem?.enabled = false
            break
        case 2:
            self.headerView.frame = CGRectMake(0,0,0,0)
            self.headerView.hidden = true
            self.tableView.tableHeaderView = self.headerView
            self.navigationItem.rightBarButtonItem?.enabled = false
            break
        default:
            self.headerView.frame = CGRectMake(0,0,600,260)
            self.headerView.hidden = false
            self.tableView.tableHeaderView = self.headerView
            self.navigationItem.rightBarButtonItem?.enabled = true
            break
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            return info.count-1
        case 1:
            if section == 0 {
                return 4
            }
            else {
                return tuteeSession.info.count
            }
        case 2:
            return tutorSession.info.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell", forIndexPath: indexPath) as! InfoTableViewCell
            let entry = info[indexPath.row+1]
            cell.keyLabel.text = entry.key
            cell.valueLabel.text = entry.value
            
            return cell
        case 1:
            if indexPath.section == 0 {
                if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell", forIndexPath: indexPath)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell", forIndexPath: indexPath) as! ReviewTableViewCell
                    cell.tuteeImageView.image = UIImage(named:"stormtrooper")
                    cell.ratingLabel.text = "★ 4.1"
                    cell.dateLabel.text = "Jun.14.2031"
                    cell.reviewTextLabel.text = "Share on Facebook (226)  Tweet (774)  Share (18)  Pin (1) The hearts reign of terror as the only emoji-based reaction to a tweet may be coming to an end. Twitter user _Ninji noticed the ability to select multiple emoji from the heart, including the frown, the grimace, the party nois"
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
                let entry = tuteeSession.info[indexPath.row]
                cell.tutorImageView.image = UIImage(named:entry.image)
                cell.titleLabel.text = entry.title
                cell.categoryLabel.text = entry.category
                cell.tagLabel.text = entry.tag
                cell.locationLabel.text = entry.location
                cell.timeLabel.text = entry.time
                cell.capacityLabel.text = entry.capacity
                cell.ratingLabel.text = entry.rating
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
            let entry = tutorSession.info[indexPath.row]
            cell.tutorImageView.image = UIImage(named:entry.image)
            cell.titleLabel.text = entry.title
            cell.categoryLabel.text = entry.category
            cell.tagLabel.text = entry.tag
            cell.locationLabel.text = entry.location
            cell.timeLabel.text = entry.time
            cell.capacityLabel.text = entry.capacity
            cell.ratingLabel.text = entry.rating
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell", forIndexPath: indexPath) as! InfoTableViewCell
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 1:
            if section == 0 {
                return "Review"
            }
            else {
                return "History"
            }
        case 2:
            return "History"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: "Avenir-Heavy", size: 15)!
        header.textLabel!.textColor = UIColor.lightGrayColor()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell") as! InfoTableViewCell
            return cell.bounds.height
        case 1:
            if indexPath.section == 0 {
                if (indexPath.row == 3) {
                    let cell = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell")
                    return cell!.bounds.height
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell") as! ReviewTableViewCell
                    return cell.bounds.height
                }
                
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
                return cell.bounds.height
            }
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            return cell.bounds.height
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            return cell.bounds.height
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sessionInfo" {
            let dstController = segue.destinationViewController as! SessionInfoViewController;
            //dstController.xxx = xxx
        }
        else if segue.identifier == "reviewInfo" {
            let dstController = segue.destinationViewController as! ReviewTableViewController;
        }
    }
    
}