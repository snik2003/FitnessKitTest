//
//  ViewController.swift
//  FitnessKitTest
//
//  Created by Сергей Никитин on 25/02/2020.
//  Copyright © 2020 Snik2003. All rights reserved.
//

import UIKit
import SwiftyJSON

class StartViewController: InnerViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var shedules = Shedules()
    var records: [Record] = []
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sheduleCell")
        
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshSchedule), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        shedules.load()
        self.records = shedules.shedule
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !Reachability.shared.isConnectedToNetwork() {
            showAttention(message: Settings.shared.noInternetError)
            return
        }
        
        showHUD()
        getSheduleFromServer(success: { records in
            self.shedules.shedule = records
            self.shedules.save()
            
            OperationQueue.main.addOperation {
                self.records = records
                self.tableView.reloadData()
                self.hideHUD()
            }
        }, failure: {
            OperationQueue.main.addOperation {
                self.hideHUD()
                self.showServerError()
            }
        })
    }
    
    @objc func refreshSchedule() {
        if !Reachability.shared.isConnectedToNetwork() {
            self.refreshControl.endRefreshing()
            self.showAttention(message: Settings.shared.noInternetError)
            return
        }
        
        getSheduleFromServer(success: { records in
            self.shedules.shedule = records
            self.shedules.save()
            
            OperationQueue.main.addOperation {
                self.records = records
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }, failure: {
            OperationQueue.main.addOperation {
                self.refreshControl.endRefreshing()
                self.showServerError()
            }
        })
    }
    
    func getSheduleFromServer(success: @escaping ([Record])->(), failure: @escaping ()->()) {
        
        let url = Settings.shared.url + Method.getShedule.rawValue
        let request = GetServerDataOperation(url: url, method: .get, headers: [:])
        
        request.completionBlock = {
            guard let data = request.data else { failure(); return }
            guard let json = try? JSON(data: data) else { failure(); return }
            
            //print(json)
            let records = json.compactMap({ Record(json: $0.1) })
            success(records)
        }
        OperationQueue().addOperation(request)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let record = self.records[indexPath.row]
        
        let size = CGSize(width: screenWidth - 40, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: Settings.shared.fontDescName, size: 15)!]
        let height = record.descript.boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return height + 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sheduleCell", for: indexPath)
        cell.backgroundColor = .white
        
        let record = self.records[indexPath.row]
        
        let size = CGSize(width: screenWidth - 40, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: Settings.shared.fontDescName, size: 15)!]
        let height = record.descript.boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        for subview in cell.subviews {
            if subview.tag == 1111 { subview.removeFromSuperview() }
        }
        
        let shadowView = UIView()
        shadowView.tag = 1111
        shadowView.frame = CGRect(x: 10, y: 5, width: screenWidth - 20, height: height + 125)
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 4
        shadowView.layer.borderWidth = 0.8
        shadowView.layer.borderColor = UIColor(white: 0, alpha: 0.38).cgColor
        shadowView.dropShadow(color: UIColor(white: 0, alpha: 0.7), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 4, scale: true)
        cell.addSubview(shadowView)
        
        var topY: CGFloat = 10
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 10, y: topY, width: screenWidth - 40, height: 20)
        titleLabel.font = UIFont(name: Settings.shared.fontTitleName, size: 20)
        titleLabel.text = record.name
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.textAlignment = .center
        shadowView.addSubview(titleLabel)
        
        topY += 25
        
        let timeLabel = UILabel()
        timeLabel.frame = CGRect(x: 10, y: topY, width: screenWidth - 40, height: 15)
        timeLabel.font = UIFont(name: Settings.shared.fontName, size: 15)
        timeLabel.text = "Время: \(record.startTime) - \(record.endTime)"
        timeLabel.textColor = .black
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.6
        shadowView.addSubview(timeLabel)
        
        topY += 20
        
        let teacherLabel = UILabel()
        teacherLabel.frame = CGRect(x: 10, y: topY, width: screenWidth - 40, height: 15)
        teacherLabel.font = UIFont(name: Settings.shared.fontName, size: 15)
        teacherLabel.text = "Преподаватель: \(record.teacher)"
        teacherLabel.textColor = .black
        teacherLabel.adjustsFontSizeToFitWidth = true
        teacherLabel.minimumScaleFactor = 0.6
        shadowView.addSubview(teacherLabel)
        
        topY += 20
        
        let placeLabel = UILabel()
        placeLabel.frame = CGRect(x: 10, y: topY, width: screenWidth - 40, height: 15)
        placeLabel.font = UIFont(name: Settings.shared.fontName, size: 15)
        placeLabel.text = "Место: \(record.place)"
        placeLabel.textColor = .black
        placeLabel.adjustsFontSizeToFitWidth = true
        placeLabel.minimumScaleFactor = 0.6
        shadowView.addSubview(placeLabel)
        
        topY += 20
        
        let weekDayLabel = UILabel()
        weekDayLabel.frame = CGRect(x: 10, y: topY, width: screenWidth - 40, height: 15)
        weekDayLabel.font = UIFont(name: Settings.shared.fontName, size: 15)
        weekDayLabel.text = "День недели: \(record.weekDay.getStringWeekDay())"
        weekDayLabel.textColor = .black
        weekDayLabel.adjustsFontSizeToFitWidth = true
        weekDayLabel.minimumScaleFactor = 0.6
        shadowView.addSubview(weekDayLabel)
        
        topY += 20
        
        let descLabel = UILabel()
        descLabel.frame = CGRect(x: 10, y: topY, width: screenWidth - 40, height: height)
        descLabel.font = UIFont(name: Settings.shared.fontDescName, size: 15)
        descLabel.text = record.descript
        descLabel.textColor = .black
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        shadowView.addSubview(descLabel)
        
        cell.selectionStyle = .none
        return cell
    }
}

