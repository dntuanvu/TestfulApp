//
//  ChatViewController.swift
//  TestfulApp
//
//  Created by Home on 2/10/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var listChat: NSMutableArray = NSMutableArray()
    var cachedImages = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatTableView.estimatedRowHeight = 110.0
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        
        self.fetchDataRequest()
    }
    
    func fetchDataRequest() {
        DataManager.shared.getDataRequest(completionHandler: { (success, data) in
            if success {
                let listMessage: NSArray = data as! NSArray
                for m in listMessage {
                    let obj: ChatModel = ChatModel()
                    let avatarUrl = (m as! NSDictionary).object(forKey: "avatarURL") as! String
                    let nickname = (m as! NSDictionary).object(forKey: "fullname") as! String
                    let text = (m as! NSDictionary).object(forKey: "message") as! String
                    
                    let lastUpdated = (m as! NSDictionary).object(forKey: "sendingDate") as! Date
                    
                    let unreadMsg = (m as! NSDictionary).object(forKey: "unreadMessagesCount") as! Int
                    
                    obj.avatarUrl = avatarUrl
                    obj.nickname = nickname
                    obj.content = text
                    obj.lastUpdated = self.parseDateFromString(date: lastUpdated)
                    obj.unreadMsg = unreadMsg
                    
                    self.listChat.add(obj)
                    
                    DispatchQueue.main.async(execute: {
                        self.chatTableView.reloadData()
                    })
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatTableViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        var chatObj: ChatModel = ChatModel()
        chatObj = self.listChat.object(at: indexPath.row) as! ChatModel
        
        if let photo = chatObj.avatarUrl {
            print("avatar=\(photo)")
            let imageURL = photo
            if let image = cachedImages[imageURL] {
                cell.profileImageView.image = image
            } else {
                if let checkedUrl = URL(string: photo) {
                    getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async() { () -> Void in
                            let myPicture = UIImage(data: data)!
                            self.cachedImages[imageURL] = myPicture
                            cell.profileImageView.image = myPicture
                        }
                    }
                }
            }
        }
        
        cell.nickNameLabel.text = chatObj.nickname!
        cell.contentLabel.text = chatObj.content!
        cell.timeLabel.text = chatObj.lastUpdated!
        cell.unreadLabel.text = "+ \(chatObj.unreadMsg!) messages"
        
        return cell
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func parseDateFromString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }
    
    @IBAction func closeChat(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
