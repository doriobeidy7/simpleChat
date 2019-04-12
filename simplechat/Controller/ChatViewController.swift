//
//  ChatViewController.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    let dialogViewModel = DialogViewModel()
    var chatData = [Chat]()
    
    var botModel = [BotModel]()
    //    var bot: BotModel
    
    var rowNumber = 0
    
    @IBOutlet weak var messageTfld: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dialogViewModel.delegate = self
        
        let bot =  botModel[0]
        
        dialogViewModel.getChatList(botName: bot.name)
        refreshTableview()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        reloadMessages()
        
    }
    
    
    
    
}
