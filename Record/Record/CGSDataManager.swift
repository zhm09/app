//
//  CGSDataManager.swift
//  CongressSearch
//

import UIKit
import CoreData


class CGSDataManager: NSObject {
    static let shareInstance:CGSDataManager = CGSDataManager()
    
    //添加record
    
    func insertRecordData(entity:RecordListModel) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.managedObjectContext
        let recordData = NSEntityDescription.insertNewObject(forEntityName: "RecordListModel", into: context) as! RecordListModel
        let ivars = entity.entity.attributesByName.keys
        for nName in ivars {
            recordData.setValue(entity.value(forKey: nName), forKey: nName)
        }
        context.insert(recordData)
        do {
            try context.save()
            print("保存成功")
        } catch let error{
            print("context can't save!, Error: \(error)")
        }
    }
    
    
    //获取record
    func fetchFinishedRecordData () -> [RecordListModel]? {
        //加载AppDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        // 声明数据请求实体
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordListModel")
        let sort = NSSortDescriptor(key:"time" , ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate.init(format: "isFinished == true")
        //执行查询操作
        do {
            let recordList =
                try context.fetch(fetchRequest) as! [RecordListModel]
            print("打印查询结果")
            return recordList
        }catch let error{
            print("context can't fetch!, Error: \(error)")
        }
        return nil
    }
    //获取record
    func fetchUnfinishedRecordData () -> [RecordListModel]? {
        //加载AppDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        // 声明数据请求实体
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordListModel")
        let sort = NSSortDescriptor(key:"time" , ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate.init(format: "isFinished == false")
        //执行查询操作
        do {
            let recordList =
                try context.fetch(fetchRequest) as! [RecordListModel]
            
            print("打印查询结果")
            return recordList
        }catch let error{
            print("context can't fetch!, Error: \(error)")
        }
        return nil
    }
    //删除record
    func deleteRecordData(objectID:NSManagedObjectID) -> Void {
        //加载AppDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        // 声明数据请求实体

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordListModel")
        fetchRequest.predicate = NSPredicate.init(format: "objectID==\(objectID)")
        let object = try! context.fetch(fetchRequest)
        context.delete(object[0] as! NSManagedObject)
        
        do {
            try context.save()
            print("保存成功")
        } catch let error{
            print("context can't save!, Error: \(error)")
        }
    }
    
    //删除record
    func deleteRecordData(object:RecordListModel) -> Void {
        //加载AppDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        // 声明数据请求实体
        
        context.delete(object as NSManagedObject)
        
        do {
            try context.save()
            print("保存成功")
        } catch let error{
            print("context can't save!, Error: \(error)")
        }
    }
    
    //更新record
    func updateRecordData(object:RecordListModel) -> Void {
        //加载AppDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        // 声明数据请求实体
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordListModel")
        fetchRequest.predicate = NSPredicate.init(format: "time== %@", object.time!)
               // object.setValue(true, forKey: "isFinished")
        //context.delete(object as NSManagedObject)
        var error: NSError? = nil
        //执行查询操作
        do {
            let recordList =
                try context.fetch(fetchRequest) as! [RecordListModel]
            print("打印查询结果")
            recordList[0].setValue(true, forKey: "isFinished")
            do {
                try context.save()
                print("保存成功")
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }catch let error{
            print("context can't fetch!, Error: \(error)")
        }
        
        
    }
  }
