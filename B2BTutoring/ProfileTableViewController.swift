//
//  ProfileTableViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/29.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    let profile = Profile()
    let tuteeSession = TuteeSession()
    let tutorSession = TutorSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = profile.info[0].value

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
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell") as! InfoTableViewCell
            self.tableView.rowHeight = cell.bounds.height
            break
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            self.tableView.rowHeight = cell.bounds.height
            break
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            self.tableView.rowHeight = cell.bounds.height
            break
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            self.tableView.rowHeight = cell.bounds.height
            break
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            return profile.info.count-1
        case 1:
            return tuteeSession.info.count
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
            let entry = profile.info[indexPath.row+1]
            cell.keyLabel.text = entry.key
            cell.valueLabel.text = entry.value
            
            return cell
        case 1:
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
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            return 44
        case 1:
            return 120
        case 2:
            return 120
        default:
            return 120
        }
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
