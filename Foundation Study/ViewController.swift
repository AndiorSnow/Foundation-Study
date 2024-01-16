//
//  ViewController.swift
//  Foundation Study
//
//  Created by LMC60018 on 2024/1/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        userInfoFromNetwork(name: "Arvin")
        
        print("uuid: \(userInfoFromLocal())")
        
        
        // Storage and reading of native data types
        let userDefault = UserDefaults.standard
        // Any
        userDefault.setValue("line.com", forKey: "Object")
        let objectiveValue: Any? = userDefault.object(forKey: "Object")
        // Int
        userDefault.setValue(123, forKey: "Int")
        let intValue = userDefault.integer(forKey: "Int")
        // Float, Double, Bool, URL, String
        // NSNumber, Array, Dictionary
        var dictionary = ["1": "line.com"]
        userDefault.setValue(dictionary, forKey: "Dictionary")
        dictionary = userDefault.dictionary(forKey: "Dictionary") as! [String: String]
        
        // Storage and Reading of System Objects
        // UILabel storage
        // Convert objects to a Data stream
//        let label = UILabel()
//        label.text = "This is a system object."
//        let labelData = try? NSKeyedArchiver.archivedData(withRootObject: label, requiringSecureCoding: false)
//        // store Data object
//        userDefault.setValue(labelData, forKey: "labelData")
//        // UILabel reading
//        // get Data
//        let objData1 = userDefault.data(forKey: "labelData")
//        // restore object
//        let myLabel = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UILabel.self, from: objData1!)
//        print(myLabel!)
        
        // UIImage
        // If image1 is directly stored and then converted back to UIImage, it becomes nil.
        // It must be converted to image2 before storing.
        let image1 = UIImage(named: "swift")!
        let image2 = UIImage(cgImage: image1.cgImage!, scale: image1.scale, orientation: image1.imageOrientation)
        let imageData = try? NSKeyedArchiver.archivedData(withRootObject: image2, requiringSecureCoding: true)
        userDefault.setValue(imageData, forKey: "imageData")
        
        let objData2 = userDefault.data(forKey: "imageData")
        let myImage = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: objData2!)
        print(myImage!)
        
        // Delete storage object
        UserDefaults.standard.removeObject(forKey: "Object")
        
        
        // A better way to use UserDefault
        UserDefaults.AccountInfo.set(value: "chilli cheng", forKey: .userName)
        let userName = UserDefaults.AccountInfo.string(forKey: .userName)
                
        UserDefaults.LoginInfo.set(value: "ahdsjhad", forKey: .token)
        let token = UserDefaults.LoginInfo.string(forKey: .token)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // URLSession
    func userInfoFromNetwork(name: String) {
        // Create URL
        guard let url: URL = URL(string: "https://api.github.com/users/\(name)") else {
            return
        }
        
        // Create URLRequest
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create URLSession
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        // URLSession subclass
        let task = URLSession.shared.dataTask(with: request) { (data, request, error) in
            if let theData = data {
                do  {
                    let userInfo = try JSONDecoder().decode(UserURLInfo.self, from: theData)
                    print(userInfo)
                } catch {
                    print(error)
                }
            }
            
        }
        
        // Resume the task
        task.resume()
    }
    
    
    // UserDefaults
    func userInfoFromLocal() -> String {
        let userId = UserDefaults.standard.string(forKey: "id")
        // Determine if UserFaults already exist.
        if (userId != nil) {
            return userId!
        } else {
            // If it does not exist, generate a new one and save it.
            let uuidRef = CFUUIDCreate(nil)
            let uuidStringRef = CFUUIDCreateString(nil, uuidRef)
            let uuid = uuidStringRef! as String
            UserDefaults.standard.setValue(uuid, forKey: "id")
            return uuid
        }
        
        
    }

}


// Precedent context
protocol UserDefaultsSettable {
    // RawRepresentable protocol, can switch between custom types and associated RawValue types without losing the value of the original RawRepresentable type
    associatedtype defaultKeys: RawRepresentable
}

// Extend the protocol and provide default implementation of protocol methods
extension UserDefaultsSettable where defaultKeys.RawValue == String {
    // No need to write “rawValue” and "UserDefaultKeys.AccountInfo" during implementation
    // storage
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    // reading
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
}

// Extend custom methods
extension UserDefaults {
    struct AccountInfo: UserDefaultsSettable {
        // Enumeration can not only group and set keys, but also default to rawValue of the key
        enum defaultKeys: String {
            case userName
            case age
        }
    }
    
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
        }
    }
}
