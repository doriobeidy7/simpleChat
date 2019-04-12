//
//  ChatViewExtension.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension ChatViewController: DialogViewModelDelegate {
    
    func reloadMessages()  {
        let bot =  botModel[0]
        dialogViewModel.createMessage(botId: bot.botId, message: messageTfld.text!, botName: bot.name, botDate: bot.createdDate, messageDate: Date())
        
        dialogViewModel.getChatList(botName: bot.name)
        
        refreshTableview()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.dialogViewModel.getChatList(botName: bot.name)
            self.refreshTableview()
        }
    }
    
    
    func loadChatList() {
        let bot =  botModel[0]
        dialogViewModel.getChatList(botName: bot.name)
        self.rowNumber = self.chatData.count
        refreshTableview()
        
    }
    
    func didRecieveDataUpdate(data: [BotModel], botNameArray: [String]) {
        chatData = data[0].botChats
        
        self.chatData = data[0].botChats
        self.rowNumber = data[0].botChats.count
    
        self.refreshTableview()
        
        
    }
    
    func didFailDataUpdateWithError(error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    //Get chat list name
    func refreshTableview()  {
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView?.reloadData()
            
            if(self.rowNumber > 1){
                self.tableView.tableViewScrollToBottom(animated: false, rowNumber: self.rowNumber - 1)
            }
            
        })
    }
    
    
}


// MARK: - UITableView Data Source
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
        
        let dateFormated =  chatData[indexPath.row].date.dateFormatted(with: "yyyy-MM-dd HH:mm:ss", date: chatData[indexPath.row].date)

        
        chatViewCell.NameLabel.text? = chatData[indexPath.row].from
        chatViewCell.messageLabel.text? = chatData[indexPath.row].message
        chatViewCell.dateLabel.text? = String(describing: dateFormated)
        
        return chatViewCell
    }
    
    
}// end extension DialogViewController : UITableViewDataSource


// MARK: - UITableView Delegate
extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let endScrolling:CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if(endScrolling >= scrollView.contentSize.height){
            
            //loadData()
            
        }
    }
}// end extension DialogViewController : UITableViewDelegate
