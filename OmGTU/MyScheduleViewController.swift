//
//  MyScheduleViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class MyScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var days:Array<Day> = []
    let SectionHeaderHeight: CGFloat = 25
    
    var currDay = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let placesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.mySchedule.rawValue) as? NSData else {
            print("'\(UserDefaultsKeys.mySchedule.rawValue)' not found in UserDefaults")
            return
        }
        
        guard let _days = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [Day] else {
            print("Could not unarchive from placesData")
            return
        }
        
        days = _days
    }
    
    //MARK: UITableViewDataSource    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.days.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.days[section].dayTitle
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.textAlignment = .center

        if section == 0 {
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.textColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
            view.backgroundColor = UIColor(red: 0.0/255.0, green: 84.0/255.0, blue: 147.0/255.0, alpha: 1)
        }
        else {
            label.textColor = UIColor.black
            view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 13)
            
            let button = UIButton(frame: CGRect(x: tableView.bounds.width - 30, y: (SectionHeaderHeight - 20) / 2 + 1, width: 20, height: 20))
            button.titleLabel?.text = ""
            button.setImage(UIImage(named:"edit"), for: .normal)
            button.tag = section
            button.addTarget(self, action: #selector(self.addNote(sender:)), for: .touchUpInside)
            
            view.addSubview(button)
        }
        
        label.text = self.days[section].dayTitle
        view.addSubview(label)
        
        return view
    }
    
    @objc func addNote(sender: UIButton!) {
        currDay = sender.tag
        performSegue(withIdentifier: "addNoteSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNoteSegue" {
            let enc = segue.destination as! EditNoteViewController
            let caption = self.days[currDay].dayTitle
            enc.captionText = caption

            if let note = RequestsEngine.shared.getNote(forKey: self.days[currDay].dayTitle) {
                enc.noteText = note
            }
            else {
                enc.noteText = ""
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days[section].dayLessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LectureTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellID") as! LectureTableViewCell
        cell.timeLabel.text = self.days[indexPath.section].dayTimes[indexPath.row]
        cell.nameLabel.text = self.days[indexPath.section].dayLessons[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
}
