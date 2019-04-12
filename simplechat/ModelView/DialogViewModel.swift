//
//  DialogViewModel.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit


//DIALOG VIEW MODEL

// HOW TO?:
// - CREATE A NEW ViewModel in the view controller:
// //let dialogViewModel = DialogViewModel()

// - CREATE NEW BOT:
// //dialogViewModel.createNewBot(botId: 1, botName: "bot NAME", botDate: Date())

// - CREATE NEW MESSAGE:
// //dialogViewModel.createMessage(botId: 1, message: "hi", botName: "bot NAME", botDate: Date(), messageDate: Date())

protocol DialogViewModelDelegate: class{
    func didRecieveDataUpdate(data: [BotModel], botNameArray: [String])
    func didFailDataUpdateWithError(error: Error)
}

class DialogViewModel: NSObject{
    
    //Handling data using delegate
    weak var delegate: DialogViewModelDelegate?
    
    var botModel: Bot = Bot()
    var chatArray = [Chat]()
    
    var botNameArray = [String]()
    var botData = [BotModel]()
    
    let delayInSeconds = 2.0
    
    
    
    func createMessage(botId: Int, message:String , botName: String,  botDate: Date,  messageDate: Date)  {
        
        let botChatsArray =  botModel.getBot(botName)?.botChats
        botChatsArray != nil ? chatArray = botModel.getBot(botName)!.botChats : nil
        
        //CREATE THE MESSAGE  - ADD IT TO CHAT ARRAY
        let chat = Chat(chatId: "1", message: message, date: messageDate, from: "me")
        chatArray.append(chat)
        
        //SAVE THE BOT AND THE CHAT ARRAY LIST RELATED FOR THE BOT CREATED
        botModel.saveBot(botId: botId,  name: botName , createdDate: botDate, botChats: chatArray)
        
        
        // DISPATCH ASYNC AFTER 2 SEC SO THE BOT REPLY THE MESSAGE TWICE
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            // PASS THE DATA TO THE BOT FUNCTION
            self.botReply(botId: botId, message: message, botName: botName, botDate: botDate, messageDate: Date())
        }
    }
    
    func botReply(botId: Int, message:String , botName: String,  botDate: Date,  messageDate: Date)  {
        
        //DUPLICATE THE MESSAGE
        let repMessage = message + " " + message
        //CREATE THE CHAT OF THE BOT
        let botChat = Chat(chatId: "2", message: repMessage, date: messageDate, from: botName)
        
        //GET ALL CHATS
        chatArray = botModel.getBot(botName)!.botChats
        //APPEND THE NEW CHAT
        chatArray.append(botChat)
        //SAVE THE BOT WITH THE CHATS
        botModel.saveBot(botId: botId,  name: botName , createdDate: botDate, botChats: chatArray)
        
    }
    
    //CREATE A NEW BOT
    func createNewBot(botId: Int, botName: String,  botDate: Date){
        //CHECK IF BOT EXIST SO DON'T CREATE IT
        checkIfBotExits(botName: botName) == false ?
            saveNewBot(botId: botId, botName: botName,  botDate: botDate) : nil
    }
    
    func saveNewBot(botId: Int, botName: String,  botDate: Date){
        
        //CREATE A BOT WITH EMPTY CHAT
        botModel.saveBot(botId: botId,  name: botName , createdDate: botDate, botChats: chatArray)
        
        
        let botListName =  UserDefaults.standard.value(forKey:  "botlist")
        var dictList = botListName as? [String]
        if(dictList != nil){
            dictList?.append(botName)
            botNameArray = dictList!
                   UserDefaults.standard.set(botNameArray, forKey: "botlist")
        }else{
            botNameArray.append(botName)
            UserDefaults.standard.set(botNameArray, forKey: "botlist")
        }

 
    }
    
    func getBot(botName: String) -> BotModel?{
        return botModel.getBot(botName)
    }
    
    func checkIfBotExits(botName: String) -> Bool {
        let botNameUSV =  UserDefaults.standard.value(forKey: botName)
        return botNameUSV == nil ? false :  true
    }
    
    //CLEAR ALL USER DEFAULT DATA
    static func clearAllData(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    
    //Get bot list
    func getBotList()  {
        botNameArray = UserDefaults.standard.value(forKey: "botlist") as? [String] ?? []
        botData = [BotModel]()
        
        for (index, _) in botNameArray.enumerated() {
            botData.append(getBot(botName: botNameArray[index])!)
        }
        
        self.setDataWithResponse(response: botData, botNameArray:  botNameArray)
        
    }
    
    //Get chat list
    func getChatList(botName: String)  {
    
        botData = [BotModel]()
        
        botData.append(getBot(botName: botName)!)
        
        self.setDataWithResponse(response: botData, botNameArray:  [])
        
    }
    
    
    private func handleError(error: Error) {}
    
    func setDataWithResponse(response: [BotModel], botNameArray: [String]) {
        delegate?.didRecieveDataUpdate(data: response, botNameArray: botNameArray)
    }
    
    
}
