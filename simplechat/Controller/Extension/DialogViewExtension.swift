//
//  DialogExtension.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit

var botName = [String?]()
var botData = [BotModel]()

// MARK: - UIViewController
extension DialogsViewController: DialogViewModelDelegate {
    
    
    func didRecieveDataUpdate(data: [BotModel], botNameArray: [String]) {
                botName = botNameArray
                botData = data
                getDataList()
    }
    
    func didFailDataUpdateWithError(error: Error) {
         print("error: \(error.localizedDescription)")
    }
    
    //Get bot list name
    func getDataList()  {

        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView?.reloadData()
            
        })
    }
    
}

// MARK: - UITableView Data Source
extension DialogsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return botName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dialogCell = tableView.dequeueReusableCell(withIdentifier: "DialogCell", for: indexPath) as! DialogCell
        
    
        
        let botdata = botData[indexPath.row]
        var fromatedDate = botdata.createdDate.dateFormatted(with: "yyyy-MM-dd HH:mm:ss", date: botdata.createdDate)
        
        if(botdata.botChats.count > 0){
            let latestDate =  botdata.botChats[botdata.botChats.count - 1].date
            fromatedDate = latestDate.dateFormatted(with:  "yyyy-MM-dd HH:mm:ss", date: latestDate)
        }

        let createdDate =  String(describing: fromatedDate)
        let botMessages = botData[indexPath.row].botChats
        var botMessage = ""
        
        botMessages.count > 0 ? botMessage = botMessages[0].message : nil
        
        dialogCell.botNameLabel.text? = botName[indexPath.row]!
        dialogCell.messageLabel.text? = botMessage
        dialogCell.dateLabel.text? = createdDate
        
        return dialogCell
    }
    
    
}// end extension DialogViewController : UITableViewDataSource


// MARK: - UITableView Delegate
extension DialogsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatView" {
          
            let cell = sender as! UITableViewCell
            let index = tableView.indexPath(for: cell)
         
            if let vc = segue.destination as? ChatViewController {
                
                if let indexPath = index?.row {
                    let selectedChats = botData[indexPath]
                    var botList = sender as? BotModel
                    botList = selectedChats
                    vc.botModel = [botList!] 
                    vc.chatData = botList?.botChats ?? []
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let endScrolling:CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if(endScrolling >= scrollView.contentSize.height){
            
            //loadData()
            
        }
    }
}// end extension DialogViewController : UITableViewDelegate
