//
//  TimeLineTableViewController.swift
//  Record
//
//  Created by Li Nan on 17/1/7.
//  Copyright © 2017年 nancy. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController {

    var dataList:[RecordListModel] = []
    
    var tripules:[(TimelinePoint, UIColor, String, String)] = []
    var data:[Int: [(TimelinePoint, UIColor, String, String)]]  = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        initDate()
    }

    func initDate() -> Void {
        self.dataList = CGSDataManager.shareInstance.fetchFinishedRecordData()!
        var index:Int = 0;
        for model: RecordListModel in dataList
        {
            let formatter = DateFormatter()
            let timeZone = TimeZone.init(identifier: "UTC")
            formatter.timeZone = timeZone
            formatter.locale = Locale.init(identifier: "zh_CN")
            formatter.dateFormat = "MM-dd HH:mm"
            let date = formatter.string(from: model.time as! Date)
            tripules.insert((TimelinePoint(), UIColor.black, date.components(separatedBy: " ").first!, model.content!), at: index)
            index = index+1
        }
        data[0] = tripules;
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = data[section] else {
            return 0
        }
        return sectionData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        // Configure the cell...
        guard let sectionData = data[indexPath.section] else {
            return cell
        }
        
        let (timelinePoint, timelineBackColor, title, description) = sectionData[indexPath.row]
        var timelineFrontColor = UIColor.clear
        if (indexPath.row > 0) {
            timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        cell.timelinePoint = timelinePoint
        cell.timeline.frontColor = timelineFrontColor
        cell.timeline.backColor = timelineBackColor
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description

        return cell
    }

}
