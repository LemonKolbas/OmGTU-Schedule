//
//  GroupsViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: GroupsHeader!

    @IBAction func saveSchedule(_ sender: UIBarButtonItem) {
        if days.count > 0 {
            let placesData = NSKeyedArchiver.archivedData(withRootObject: days)
            UserDefaults.standard.set(placesData, forKey: UserDefaultsKeys.mySchedule.rawValue)
            
            let alertController = UIAlertController(title: "Расписание сохранено", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Ошибка!", message: "Нет данных для сохранения", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    var days:Array<Day> = []
    let SectionHeaderHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let day = Day()
        day.dayTitle = "нет значений"
        days.append(day)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        headerView.initPickers()
        
        // 1. Setup AutoLayout
//        self.tableView.setTableHeaderView(headerView: self.tableView.tableHeaderView!)
//        // 2. First layout update
//        self.tableView.updateHeaderViewFrame()
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableInfo(_:)), name: NSNotification.Name(rawValue: "updateTableInfo"), object: nil)
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
        }
        
        label.text = self.days[section].dayTitle
        view.addSubview(label)
        return view
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
    
    // handle notification
    @objc func updateTableInfo(_ notification: NSNotification) {
        self.days = headerView.days
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
}
