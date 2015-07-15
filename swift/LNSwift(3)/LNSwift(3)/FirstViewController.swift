//
//  FirstViewController.swift
//  LNSwift(3)
//
//  Created by ccyy on 15/7/15.
//  Copyright (c) 2015年 111. All rights reserved.
//

import UIKit
//遵守协议直接写在父类后面
class FirstViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    
    //充当表视图的数据源
    var dataArray:Array<String> = ["1","2","3","4"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(tableView)
        
        //设置代理
        tableView.delegate = self
        tableView.dataSource = self
        


    }

 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //创建一个cell，并且指定重用标识符
       let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.dataArray[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var third = ThirdViewController()
        self.navigationController?.pushViewController(third, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
