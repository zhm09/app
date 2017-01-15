//
//  BaseModel.swift
//  Swift-TimeMovie
//
//  Created by DahaiZhang on 16/10/17.
//  Copyright © 2016年 LLQ. All rights reserved.
//

import UIKit
import CoreData
extension NSManagedObject {
    
    class func manageContex(keyValues:[String:AnyObject]) -> NSManagedObject {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.managedObjectContext
        let fileName:String = NSStringFromClass(self.classForCoder())
        let entityName = fileName.components(separatedBy: ".").last
        
        let entity:NSManagedObject = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: fileName, in: context)!, insertInto: nil)
        entity.setAttribut(dic: keyValues)
        return entity
    }
    
    func setAttribut(dic: [String:AnyObject]) -> Void {
        let attributDic = attributesDic(dic: dic)
        let ivars = self.entity.attributesByName.keys
        for nName in ivars {
            //取出属性名
            var attribut = attributDic[nName]
            if attribut == nil{
                attribut = ""
            }
            var value:NSObject
            if (dic[attribut!] != nil && NSStringFromClass((dic[attribut!]?.classForCoder)!) != "NSNull") {
                if dic[attribut!] != nil {
                    value = dic[attribut!] as! NSObject
                } else {
                    value = "" as NSObject
                }
                
            } else {
                value = "" as NSObject
            }
            
            //利用KVC给本类的属性赋值
            self.setValue(value, forKey: nName)
            
        }
    }
    
    //如果属性名与数据字典的key值不对应，那么在子类model中复写此方法，将属性名作为key，字典key值作为value
    func attributesDic(dic: [String:Any]) -> [String:String] {
        
        var newDic:[String:String] = [:]
        
        for key in dic.keys {
            //复写时注意将属性名作为key 数据字典的key作为value
            newDic[key] = key
        }
        
        return newDic
    }

}
