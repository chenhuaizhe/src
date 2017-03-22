//
//  CloudDataManager.swift
//  Selfies
//
//  Created by CY on 2017/3/17.
//  Copyright © 2017年 chenyuan. All rights reserved.
//

import UIKit
import CloudKit

class CloudDataManager: NSObject {
    
//    var document: MyDocument?
    var documentURLs: URL?
    var ubiquityURLOfImg: URL?
    var metaDataQuery: NSMetadataQuery?
    var cloudURLs: [URL]?
    var localURLs: [URL]?
    
    static let sharedInstance = CloudDataManager()
    
    
    func syncDataWithICloud() {
//        //初始化img文件夹的url
//        self.initUbiquityURLOfImg()
       
        if self.isICloudAvaliable() {
            //初始化本地文件url数组
            self.initLocalURLs()
            //获取云端文件url数组
            self.askForCloudDataQuery()
        }
    }
    
    func isICloudAvaliable() -> Bool {
        self.initUbiquityURLOfImg()
        if ubiquityURLOfImg == nil {
            return false
        }else {
            return true
        }
    }
    
    
    //查询云端的文件
    func askForCloudDataQuery() {
        metaDataQuery = NSMetadataQuery()
        metaDataQuery?.searchScopes =
            [NSMetadataQueryUbiquitousDocumentsScope]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(
                                                CloudDataManager.metadataQueryDidFinishGathering),
                                               name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
                                               object: metaDataQuery!)
        metaDataQuery!.start()
    }

    
    //获取到云端的所有的文件的url，保存到cloudURLs数组里面
    func metadataQueryDidFinishGathering(notification: NSNotification) -> Void
    {
        let query: NSMetadataQuery = notification.object as! NSMetadataQuery
        query.disableUpdates()
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
                                                  object: query)
        query.stop()
        print("query.valueLists = \(query.valueLists),query.resultCount = \(query.resultCount)")
        if cloudURLs == nil {
            cloudURLs = Array.init()
        }else {
            cloudURLs?.removeAll()
        }
        if query.resultCount != 0 {
            let count = (query.results as Array).count

            for i in 0..<count{
                let resultURL = query.value(ofAttribute: NSMetadataItemURLKey,
                                            forResultAt: i) as! URL
             
                cloudURLs?.append(resultURL)
            }
            print("cloudURLs = \(cloudURLs!)")
            //下载到本地
            self.downloadFileToLocal()

        }
        //上传到云端
        self.uploadFileToCloud()
        
    }
    
    //获得本地所有文件的需要上传到cloud的时候的url，保存到localURLs数组里面
    func initLocalURLs() {
        if localURLs == nil {
            localURLs = Array.init()
        }else {
            localURLs?.removeAll()
        }
        let allImgNames = Utils.getAllFileNameInImgFolder()
        for imgName in allImgNames {
            let imgURL = ubiquityURLOfImg?.appendingPathComponent(imgName)
            localURLs?.append(imgURL!)
        }
        print("localURLs = \(localURLs)")

    }
    
    //给UbiquityURLOfImg初始化
    func initUbiquityURLOfImg() {
        let filemgr = FileManager.default
        let ubiquityURL = filemgr.url(forUbiquityContainerIdentifier: nil)
        
        //如果ubiquityURL = nil，可能是没有登录账户，或者没有打开iCloud
        guard ubiquityURL != nil else {
            print("Unable to access iCloud Account")
            print("Open the Settings app and enter your Apple ID into iCloud settings")
            return
        }
        ubiquityURLOfImg = ubiquityURL?.appendingPathComponent(
            "Documents")
    }
    
    //获取要上传到icloud的url的数组
    func getNeedUploadToCloudUbiquityURLArray() -> [URL] {
        var finalArr = localURLs
        for local in localURLs! {
            for cloud in cloudURLs! {
                if cloud == local {
                    let index = finalArr?.index(of: local)
                    finalArr?.remove(at: index!)
                    continue
                }
            }
        }
        print("getNeedUploadToCloudUbiquityURLArray finalArr = \(finalArr!)")
        return finalArr!
    }
    
    //获取要保存到本地的url的数组
    func getNeedDownloadTolocalUbiquityURLArray() -> [URL] {
        var finalArr = cloudURLs
        for cloud  in cloudURLs! {
            for local in  localURLs! {
                if cloud == local {
                    let index = finalArr?.index(of: cloud)
                    finalArr?.remove(at: index!)
                    continue
                }
            }
        }
        print("getNeedDownloadTolocalUbiquityURLArray finalArr = \(finalArr!)")
        return finalArr!
    }
    
    //保存文件到本地
    func downloadFileToLocal()  {
        //保存文件到本地
        let downloadArr = cloudURLs!// self.getNeedDownloadTolocalUbiquityURLArray()
        for ubiquityURL in downloadArr {
            let fileName = ubiquityURL.path.components(separatedBy: "/").last
            let document = MyDocument(fileURL: ubiquityURL as URL)
            document.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    let data = document.data
                    if data == nil {
                        print("iCloud file open failed,error ,data = nil ")

                    }else {
                        Utils.saveFileToImgFolder(fileName: fileName!, data: data!)
                        print("iCloud file open OK")
                    }
                    
                } else {
                    print("iCloud file open failed")
                }
            })
        }
    }
    
    //上传文件到云端
    func uploadFileToCloud()  {
        //上传文件到icloud
        let uploadArr = self.getNeedUploadToCloudUbiquityURLArray()
        for ubiquityURL2 in uploadArr {
            let document = MyDocument(fileURL: ubiquityURL2)
            let fileName = ubiquityURL2.path.components(separatedBy: "/").last

            let fileManager = FileManager.default
            let fullpath = Utils.getImgFolderPath().appending("/\(fileName!)")
            if fileManager.fileExists(atPath: fullpath) {
//                print("FILE AVAILABLE")
            } else {
                print("FILE NOT AVAILABLE at \(fullpath)")
            }
            let img = UIImage.init(contentsOfFile: fullpath);
            if (img != nil) {
                let imgData = NSData.init(contentsOfFile: fullpath)
                document.imgData = imgData
            }
            document.save(to: ubiquityURL2,
                           for: .forOverwriting,
                           completionHandler: {(success: Bool) -> Void in
                            if success {
                                print("iCloud create OK \(ubiquityURL2)")
                            } else {
                                print("iCloud create failed \(ubiquityURL2)")
                            }
            })
        }
    }
    
    //上传当天的照片到云端
    func uploadTodayPictureToCloud() {
        if !self.isICloudAvaliable() {
            return;
        }
        let todayImgName = Utils.getTodayDateString()
        let todayUbiquityURL = ubiquityURLOfImg!.appendingPathComponent("\(todayImgName).png")
        let document = MyDocument(fileURL: todayUbiquityURL)
        let fileManager = FileManager.default
        let fullpath = Utils.getImgFolderPath().appending("/\(todayImgName).png")
        if fileManager.fileExists(atPath: fullpath) {
            //                print("FILE AVAILABLE")
        } else {
            print("FILE NOT AVAILABLE at \(fullpath)")
        }
        let img = UIImage.init(contentsOfFile: fullpath);
        if (img != nil) {
            let imgData = NSData.init(contentsOfFile: fullpath)
            document.imgData = imgData
        }
        document.save(to: todayUbiquityURL,
                      for: .forOverwriting,
                      completionHandler: {(success: Bool) -> Void in
                        if success {
                            print("iCloud overwriting/creat OK \(todayUbiquityURL)")
                        } else {
                            print("iCloud overwriting/creat failed \(todayUbiquityURL)")
                        }
        })

    }
}
