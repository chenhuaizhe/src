//
//  Utils.swift
//  Selfies
//
//  Created by CY on 2017/3/4.
//  Copyright © 2017年 chenyuan. All rights reserved.
//

import UIKit
import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}

extension NSDate: Comparable { }

class Utils: NSObject {
    
    class func getTodayDateString() -> String {
        let date = NSDate.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    
    /// 获取path路径下的所有文件或者目录的名字
    ///
    /// - Parameter path: path
    /// - Returns: 路径下所有文件或者目录的名字
    class func getPaths(inPath path:String) -> [String] {
        let manager = FileManager.default
        let contentsOfPath:[String]?
        do {
            try contentsOfPath = manager.contentsOfDirectory(atPath: path)
        } catch  {
            contentsOfPath = []
        }
        
        //contentsOfPath：Optional([fold1, test1.txt])
        print("contentsOfPath: \(contentsOfPath!)")
        if (contentsOfPath?.contains(".DS_Store"))! {
            let index = contentsOfPath?.index(of: ".DS_Store")
            contentsOfPath?.remove(at: index!)
        }
        return contentsOfPath!

    }
    
    class func getDayTextByFileName(_ fileName:String) -> String {
        let splitedArray = fileName.components(separatedBy: "-")
        let string1 = splitedArray.last
        let arr = string1?.components(separatedBy: ".")
        let string2 = arr?.first
        return string2!
    }
    
    class func getMonthNumberByFileName(_ fileName:String) -> Int {
        let splitedArray = fileName.components(separatedBy: "-")
        let string1 = splitedArray[1]
        return Int(string1)!
    }
    
    class func getYearNumberByFileName(_ fileName:String) -> Int {
        let splitedArray = fileName.components(separatedBy: "-")
        let string1 = splitedArray[0]
        return Int(string1)!
    }
    
    class func getMonthYearTextByFileName(_ fileName:String) -> String {
        let month = getMonthNumberByFileName(fileName);
        let year = getYearNumberByFileName(fileName);
        return "\(month)月 \(year)"
    }
    
    // 创建文件夹
    class func createFolder(name:String, baseUrl:NSURL) {
        let manager = FileManager.default
        let folderUrlPath = baseUrl.appendingPathComponent(name)
        
        let exist = manager.fileExists(atPath: (folderUrlPath?.path)!)
        if !exist { // 判断是否已存在此文件夹,若不存在则创建文件夹
            // withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            try? manager.createDirectory(at: folderUrlPath!, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    //以今天的日期命名图片，保存图片
    class func saveImageWithTodayDateString(_ image:UIImage) -> Bool{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let picName = Utils.getTodayDateString();
        let filePath = path.appending("/img/\(picName).png")
        let fileManager = FileManager.default;
        let data = UIImageJPEGRepresentation(image, 1.0);
        let fileExist = FileManager.default.fileExists(atPath: filePath);
        if fileExist {
            print("文件存在-",fileExist);
            do {
                try fileManager.removeItem(atPath:filePath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        Utils.createFolder(name: "img", baseUrl: NSURL(fileURLWithPath: path))
        let success = fileManager.createFile(atPath: filePath, contents: data, attributes: nil);
        print("创建文件：\(success)路径：\(filePath) 文件存在吗：\(fileExist)",data ?? "data is nil");
        return success
        
    }
    
    //返回一个数组，数组里面是document/img文件夹下对应的UIImage
    class func readImageFromImgFolder() -> NSDictionary {
        var  photoImages = [UIImage]();
        var names = [String]();
        let imgFolderPath = Utils.getImgFolderPath()
        let contentsOfPath = Utils.getAllFileNameInImgFolder();
        for fileName in contentsOfPath {
            let fileManager = FileManager.default
            let fullpath = imgFolderPath.appending("/\(fileName)")
            if fileManager.fileExists(atPath: fullpath) {
                print("FILE AVAILABLE")
            } else {
                print("FILE NOT AVAILABLE at \(fullpath)")
            }
            let img = UIImage.init(contentsOfFile: fullpath);
            if (img != nil) {
                photoImages.append(img!)
                names.append(fileName)
            }else {
                print("error fileName=\(fileName)")
            }
        }
        return ["name":names,"image":photoImages];
        
    }

    //document/img文件夹下所有的文件名
    class func getAllFileNameInImgFolder() -> [String] {
        let imgFolderPath = Utils.getImgFolderPath()
        let contentsOfPath = Utils.getPaths(inPath: imgFolderPath);
        let sortArr = contentsOfPath.sorted { (s1, s2) -> Bool in
            let arr1 = s1.components(separatedBy: ".");
            let dataString1 = arr1.first
            let date1 = Utils.stringToDate(dataString1!)
            
            let arr2 = s2.components(separatedBy: ".");
            let dataString2 = arr2.first
            let date2 = Utils.stringToDate(dataString2!)
             return date1 > date2
        }
        print("contentsOfPath = \(contentsOfPath)\nsortArr = \(sortArr)")
        return sortArr;
    }
    
    //获取img folder 的路径
    class func getImgFolderPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return path.appending("/img");
    }
    
    class func readDayMonthYearStringFromImgFolder() -> NSDictionary {
        let contentsOfPath = Utils.getAllFileNameInImgFolder();
        var days = [String]()
        var monthYears = [String]()
        for fileName in contentsOfPath {
            let day = Utils.getDayTextByFileName(fileName)
            days.append(day)
            let monthYear = Utils.getMonthYearTextByFileName(fileName)
            monthYears.append(monthYear)
            
        }
        return ["days":days,"monthYears":monthYears]
    }
    
    //将string转化成date
    class func stringToDate(_ dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:dateString)
        return date!
    }
    
    class func setStatusBarBackgroundColor(color: UIColor) {
        guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
            return
        }
        statusBar.backgroundColor = color
    }
    
    //将文件保存在img路径下
    class func saveFileToImgFolder(fileName:String,data:NSData) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = path.appending("/img/\(fileName)")
        let fileManager = FileManager.default;
        let fileExist = FileManager.default.fileExists(atPath: filePath);
        if fileExist {
            print("文件存在---",fileExist);
            return
        }
        Utils.createFolder(name: "img", baseUrl: NSURL(fileURLWithPath: path))
        let success = fileManager.createFile(atPath: filePath, contents: data as Data, attributes: nil);
        print("保存文件：\(success)路径：\(filePath) 文件存在吗：\(fileExist)");
    }
}
