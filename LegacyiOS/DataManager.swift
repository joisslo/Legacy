//
//  DataManager.swift
//  CollegeIOS
//
//  Created by Jerry Hill on 2/19/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

private let _storeInstance = Store()

class Store: NSObject
{
    class func storeInstance() -> Store
    {
        return _storeInstance
    }
    
    var image = DTO_Image()
    var user = DTO_User()
    var users = [DTO_User]()
    var states = [DTO_State]()
    var student = DTO_Student()
    var students = [DTO_Student]()
    var campuses = [DTO_Message]()
    var politics = [DTO_Politic]()
    var religions = [DTO_Religion]()
    var messages = [DTO_Message]()
}

class DataManager
{
    
    func loadAllData(completionClosure: @escaping () -> ())
    {
        self.loadAllMessages()
            {
                () in
                OperationQueue.main.addOperation
                    {
                        completionClosure()
                }
        }
    }
    
    func attemptLogin(email:String, completionClosure: @escaping () -> ())
    {
        BLL.post(params: ["email_address":email], remoteMethod: "NewLogin")
        {
            (data: NSData) in
            OperationQueue.main.addOperation {
                BLL.Extract_DTO_User(responseData: data)
                completionClosure()
            }
        }
    }
    
    func loadAllStudents(completionClosure: @escaping () -> ())
    {
        BLL.post(params: [:], remoteMethod: "GetStudents")
        {
            (data: NSData) in
            
            OperationQueue.main.addOperation
                {
                    BLL.Extract_DTO_Student(responseData: data)
                    completionClosure()
            }
        }
    }
    
    func loadAllCampuses(completionClosure: @escaping () -> ())
    {
        BLL.post(params: [:], remoteMethod: "GetCampuses")
        {
            (data: NSData) in
            
            OperationQueue.main.addOperation
                {
                    BLL.Extract_DTO_Campus(responseData: data)
                    completionClosure()
            }
        }
    }
    
    func loadAllPolitics(completionClosure: @escaping () -> ())
    {
        BLL.post(params: [:], remoteMethod: "GetPolitics")
        {
            (data: NSData) in OperationQueue.main.addOperation
                {
                    BLL.Extract_DTO_Politic(responseData: data)
                    completionClosure()
            }
        }
    }
    
    func loadAllReligions(completionClosure: @escaping () -> ())
    {
        BLL.post(params: [:], remoteMethod: "GetReligions")
        {
            (data: NSData) in OperationQueue.main.addOperation {
                BLL.Extract_DTO_Religion(responseData: data)
                completionClosure()
            }
        }
    }
    
    func loadAllMessages(completionClosure: @escaping () -> ())
    {
        BLL.post(params: [:], remoteMethod: "GetMessages")
        {
            (data: NSData) in OperationQueue.main.addOperation {
                BLL.Extract_DTO_Message(responseData: data)
                completionClosure()
            }
        }
    }
    
    func loadAllStates(completionClosure: @escaping () -> ())
    {
        BLL.post(params: [:], fullURL: "http://services.groupkt.com/state/get/USA/all")
        {
            (data: NSData) in OperationQueue.main.addOperation {
                BLL.Extract_DTO_State(responseData: data)
                completionClosure()
            }
        }
    }
    
    func printStudents()
    {
        print("*** Students ***")
        for student in Store.storeInstance().students
        {
            print("Student ID: \(student.StudentID) Name: \(student.StudentName)")
            
        }
    }
    
    func printCampuses()
    {
        print("*** Campuses ***")
        for campus in Store.storeInstance().campuses
        {
            //print( "Campus ID: \(campus.CampusName) Name: \(campus.CampusID)")
            
        }
    }
    
    func uploadImage(userID: Int, image: String, fileName: String, imageData: String, completionClosure: @escaping () -> ())
    {
        let jsonrequest = ["id": String(userID),
                           "FileName": fileName,
                           "Image": image,
                           "ImageData": imageData]
        
        
        print(jsonrequest)
        
        BLL.post(params: jsonrequest, remoteMethod: "uploadImage") {
            
            (data: NSData) in
            
            OperationQueue.main.addOperation {
                
                BLL.Extract_DTO_Image(responseData: data)
                completionClosure()
            }
        }
    }
    
}

class BLL
{
    static let BaseURL: String = "http://www.jumpcreek.com/legacy/Service1.svc/"
    
    static let BaseImageURL: String = "http://www.jumpcreek.com/legacyimages/"
    static var ErrorMessage: String = ""
    static var BaseStateService: String = "http://services.groupkt.com/state/get/USA/all"
    
    static func post(params: Dictionary<String, String>, remoteMethod: String, completionClosure: @escaping (_ data: NSData) -> ())
    {
        let urlString: String = "\(BaseURL)\(remoteMethod)"
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        do
        {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        catch
        {
            print("Error:\n \(error)")
            ErrorMessage = "\(error)"
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print("General Network error=\(String(describing: error))")
                return
            }
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            completionClosure(data as NSData)
            
        }
        task.resume()
    }
    
    static func post(params: Dictionary<String, String>, fullURL: String, completionClosure: @escaping (_ data: NSData) -> ())
    {
        let urlString: String = "\(fullURL)"
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "Get"
        
        //        do
        //        {
        //
        ////            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        ////
        ////            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        ////            request.addValue( "application/json", forHTTPHeaderField: "Accept")
        //        }
        //        catch
        //        {
        //            print("Error:\n \(error)")
        //            ErrorMessage = "\(error)"
        //            return
        //        }
        
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print("General Network error=\(String(describing: error))")
                return
            }
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            completionClosure(data as NSData)
            
        }
        task.resume()
    }
    
    static func Extract_DTO_Student(responseData: NSData)
    {
        if(responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().students.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments)
                as! [String: AnyObject]
            
            print(json)
            
            
            if let items = json["Data"] as? [[String: AnyObject]]
            {
                for item in items
                {
                    let single = DTO_Student.Create(dict: item as NSDictionary)
                    
                    Store.storeInstance().students.append(single)
                    Store.storeInstance().student = single
                    
                }
            }
        }
        catch let error
        {
            print("error parsing DTO_Student \(error)")
            return
        }
        
        return
    }
    
    static func Extract_DTO_Campus(responseData: NSData)
    {
        if(responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().campuses.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments)
                as! [String: AnyObject]
            
            print(json)
            
            
            if let items = json["Data"] as? [[String: AnyObject]]
            {
                for item in items
                {
                    let single = DTO_Campus.Create(dict: item as NSDictionary)
                    
                    // Store.storeInstance().campuses.append(single)
                    
                    
                }
            }
        }
        catch let error
        {
            print("error parsing DTO_Campus \(error)")
            return
        }
        
        return
    }
    
    static func Extract_DTO_Image(responseData: NSData)
    {
        if(responseData.length == 0)
        {
            return
        }
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments)
                as (AnyObject)
            
            print(json)
            
            if let item = json["Data"] as? [String: AnyObject] {
                
                let single = DTO_Image.Create(dict: item as NSDictionary)
                
                
                Store.storeInstance().image = single
            }
        }
        catch let error
        {
            print("error parsing DTO_Image \(error)")
            return
        }
        
        return
    }
    
    static func Extract_DTO_Politic(responseData: NSData)
    {
        if (responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().politics.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as (AnyObject)
            print(json)
            
            if let items = json["Data"] as? [[String: AnyObject]]
            {
                for item in items
                {
                    let single = DTO_Politic.Create(dict: item as NSDictionary)
                    
                    Store.storeInstance().politics.append(single)
                    
                    
                }
            }
        }
        catch let error
        {
            print("Error parsing DTO_Politic \(error)")
            return
        }
        return
    }
    
    static func Extract_DTO_Religion(responseData: NSData)
    {
        if (responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().religions.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as (AnyObject)
            print(json)
            
            if let items = json["Data"] as? [[String: AnyObject]]
            {
                for item in items
                {
                    let single = DTO_Religion.Create(dict: item as NSDictionary)
                    
                    Store.storeInstance().religions.append(single)
                    
                    
                }
            }
        }
        catch let error
        {
            print("Error parsing DTO_Religion \(error)")
            return
        }
        return
    }
    
    static func Extract_DTO_Message(responseData: NSData)
    {
        if (responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().messages.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as (AnyObject)
            print(json)
            
            if let items = json["Data"] as? [[String: AnyObject]]
            {
                for item in items
                {
                    let single = DTO_Message.Create(dict: item as NSDictionary)
                    
                    Store.storeInstance().messages.append(single)
                    
                    
                }
            }
        }
        catch let error
        {
            print("Error parsing DTO_Message \(error)")
            return
        }
        return
    }
    
    static func Extract_DTO_User(responseData: NSData)
    {
        if (responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().users.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as (AnyObject)
            print(json)
            
            if let items = json["Data"] as? [[String: AnyObject]]
            {
                for item in items
                {
                    let single = DTO_User.Create(dict: item as NSDictionary)
                    
                    Store.storeInstance().users.append(single)
                    
                    
                }
            }
        }
        catch let error
        {
            print("Error parsing DTO_User \(error)")
            return
        }
        return
    }
    
    static func Extract_DTO_State(responseData: NSData)
    {
        if (responseData.length == 0)
        {
            return
        }
        
        Store.storeInstance().states.removeAll()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: .allowFragments) as (AnyObject)
            print(json)
            if let dictResponse = json as? [String: Any] {
                if let restResponse = dictResponse["RestResponse"] as? [String: AnyObject] {
                    print("*** Rest Response ***")
                    print("\(restResponse)")
                    if let messages = restResponse["messages"] as? [AnyObject] {
                        print(messages)
                        if let results = restResponse["result"] as? [AnyObject] {
                            for result in results {
                                let single = DTO_State.Create(dict: result as! NSDictionary)
                                Store.storeInstance().states.append(single)
                            }
                        }
                    }
                }
            }
        }
        catch let error
        {
            print("Error parsing DTO_State \(error)")
            return
        }
        return
    }
    
}


class DTO
{
    
    static func parse(dict: NSDictionary, key: String) -> String
    {
        if let i = dict.value(forKey: key) as? String
        {
            return i
        }
        else
        {
            return ""
        }
    }
    
    static func parse(dict: NSDictionary, key: String) -> Int
    {
        if let i = dict.value(forKey: key) as? Int
        {
            return i
        }
        else
        {
            return 0
        }
    }
    static func parse(dict: NSDictionary, key: String) -> Double
    {
        if let i = dict.value(forKey: key) as? Double
        {
            return i
        }
        else
        {
            return 0
        }
    }
    
}


class DTO_Campus: DTO
{
    var CampusID: Int = 0
    var CampusName = ""
    
    static func Create(dict: NSDictionary) -> DTO_Campus
    {
        
        let dto = DTO_Campus()
        
        dto.CampusID = parse(dict: dict, key: "CampusID")
        dto.CampusName = parse(dict: dict, key: "CampusName")
        
        return dto
        
        
    }
}

class DTO_State: DTO
{
    var id = 0
    var country = ""
    var name = ""
    var abbr = ""
    var area = ""
    var largest_city = ""
    var capital = ""
    
    static func Create(dict: NSDictionary) -> DTO_State
    {
        let dto = DTO_State()
        dto.id = parse(dict: dict, key: "id")
        dto.country = parse(dict: dict, key: "country")
        dto.name = parse(dict: dict, key: "name")
        dto.abbr = parse(dict: dict, key: "abbr")
        dto.area = parse(dict: dict, key: "area")
        dto.largest_city = parse(dict: dict, key: "largest_city")
        dto.capital = parse(dict: dict, key: "capital")
        return dto
    }
}

class DTO_Student: DTO
{
    var StudentID: Int = 0
    var StudentName = ""
    var pic = ""
    
    static func Create(dict: NSDictionary) -> DTO_Student
    {
        
        let dto = DTO_Student()
        
        dto.StudentID = parse(dict: dict, key: "StudentID")
        dto.StudentName = parse(dict: dict, key: "StudentName")
        dto.pic = parse(dict: dict, key: "pic")
        
        return dto
    }
}

class DTO_User: DTO {
    var admin_id: Int = 0
    var associate_user_id: Int = 0
    var date_of_birth: String = ""
    var email_address: String = ""
    var first_name: String = ""
    var genderType: String = "1"
    var id: Int = 0
    var image: String = ""
    var last_name: String = ""
    var middle_name: String = ""
    var password: String = ""
    var politicName: String = ""
    var religionName: String = ""
    var suffix: String = ""
    var title: String = ""
    var user_types_id: Int = 0
    var hobbies: [String] = ["def hobby 1", "def hobby 2", "def hobby 3"]
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var religion: String = ""
    var politic: String = ""
    var bio: String = ""
    var phone: String = ""
    var address: String = ""
    
    static func Create(dict: NSDictionary) -> DTO_User
    {
        
        let dto = DTO_User()
        
        dto.admin_id = parse(dict: dict, key: "admin_id")
        dto.associate_user_id = parse(dict: dict, key: "associate_user_id")
        dto.date_of_birth = parse(dict: dict, key: "date_of_birth")
        dto.email_address = parse(dict: dict, key: "email_address")
        dto.first_name = parse(dict: dict, key: "first_name")
        dto.genderType = parse(dict: dict, key: "genderType")
        dto.id = parse(dict: dict, key: "id")
        dto.image = parse(dict: dict, key: "image")
        dto.last_name = parse(dict: dict, key: "last_name")
        dto.middle_name = parse(dict: dict, key: "middle_name")
        dto.password = parse(dict: dict, key: "password")
        dto.politicName = parse(dict: dict, key: "politicName")
        dto.religionName = parse(dict: dict, key: "religionName")
        dto.suffix = parse(dict: dict, key: "suffix")
        dto.title = parse(dict: dict, key: "title")
        dto.user_types_id = parse(dict: dict, key: "user_types_id")
        
        return dto
    }
    
    static func Create(firstName: String, lastName: String, birthDate: String, email: String, pass: String, gender: String) -> DTO_User {
        let dto = DTO_User()
        dto.first_name = firstName
        dto.last_name = lastName
        dto.date_of_birth = birthDate
        dto.email_address = email
        dto.password = pass
        dto.genderType = gender
        return dto
    }
}

class DTO_Politic: DTO {
    var id = 0
    var politic = ""
    
    static func Create(dict: NSDictionary) -> DTO_Politic {
        let dto = DTO_Politic()
        dto.id = parse(dict: dict, key: "id")
        dto.politic = parse(dict: dict, key: "politic1")
        
        return dto
    }
}

class DTO_Religion: DTO {
    var id = 0
    var religion = ""
    
    static func Create(dict: NSDictionary) -> DTO_Religion {
        let dto = DTO_Religion()
        dto.id = parse(dict: dict, key: "id")
        dto.religion = parse(dict: dict, key: "religion1")
        return dto
    }
}

class DTO_Message: DTO {
    var authorName = ""
    var id = 0
    var message = ""
    var message_type_id = ""
    var title = ""
    var users_id = 0
    
    static func Create(dict: NSDictionary) -> DTO_Message {
        let dto = DTO_Message()
        
        dto.authorName = parse(dict: dict, key: "authorName")
        dto.id = parse(dict: dict, key: "id")
        dto.message = parse(dict: dict, key: "message1")
        dto.message_type_id = parse(dict: dict, key: "message_type_id")
        dto.title = parse(dict: dict, key: "title")
        dto.users_id = parse(dict: dict, key: "users_id")
        return dto
    }
}

class DTO_Login: DTO {
    var email_address = ""
    var password = ""
    
    static func Create(dict: NSDictionary) -> DTO_Login {
        let dto = DTO_Login()
        dto.email_address = parse(dict: dict, key: "email_address")
        dto.password = parse(dict: dict, key: "password")
        return dto
    }
    
    static func Create(email: String, password: String) -> DTO_User {
        let dto = DTO_User()
        dto.email_address = email
        dto.password = password
        return dto
    }
}

class DTO_Image: DTO {
    
    var imageURL = ""
    static func Create(dict: NSDictionary) -> DTO_Image {
        let dto = DTO_Image()
        dto.imageURL = parse(dict: dict, key: "url")
        return dto
    }
}

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


