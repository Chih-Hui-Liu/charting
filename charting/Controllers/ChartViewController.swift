//
//  ChartViewController.swift
//  charting
//
//  Created by Leo on 2021/1/27.
//

import UIKit
import Firebase

class ChartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let db = Firestore.firestore()
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "chart"
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: keys.cellNibName, bundle: nil), forCellReuseIdentifier: keys.cellIdentifier)
       loadMessages()
    }
    func loadMessages(){
        db.collection(keys.FStore.collectionName)
            .order(by: keys.FStore.dateField)//用order排序順序
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = [] //因addSnapshotListener是即時收聽因此若陣列未清空會導致重複對話出現
            if let e = error{
                print("get error \(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let messageSender = data[keys.FStore.senderField] as? String ,let messageBody = data[keys.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) //自動滑到最底層
                            }
                        }
                       
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text,let messageSender =  Auth.auth().currentUser?.email{
            db.collection(keys.FStore.collectionName).addDocument(data: [keys.FStore.senderField:messageSender,keys.FStore.bodyField:messageBody,keys.FStore.dateField:Date().timeIntervalSince1970]) { (error) in
                if let e = error{//dateField 主要是話了時間上排序
                    print("fault \(e)")
                }else{
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""// 送出後自動消掉原本
                    }
                    print("saved")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)//返回一開始畫面
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
}
extension ChartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: keys.cellIdentifier, for: indexPath) as! MessageCell
        if message.sender == Auth.auth().currentUser?.email{//判斷目前發送者是誰
            cell.label.text = messages[indexPath.row].body
            cell.leftImageView.isHidden = true
            cell.leftView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.rightView.isHidden = false
            cell.label.textColor = .black
            cell.rightView.backgroundColor = .green
        }else{
            cell.leftLabel.text = messages[indexPath.row].body
            cell.leftImageView.isHidden = false
            cell.leftView.isHidden = false
            cell.rightView.isHidden = true
            cell.rightImageView.isHidden = true
            cell.leftView.backgroundColor = .white
            cell.leftLabel.textColor = .black
         
        }
        return cell
    }
}
extension ChartViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
