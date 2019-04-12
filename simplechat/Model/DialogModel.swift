//
//  DilaogModel.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit

let (botIdKey, nameKey, createdDateKey, botChatsKey) = ("botId","name", "createdDate", "botChats")

struct DilaogModel: Codable {
    var bots: [BotModel]
}

struct Chat:Codable {
    var chatId: String
    var message: String
    var date: Date
    var from: String
    
}

struct BotModel:Codable {
    
    var botId: Int
    var name: String
    var createdDate: Date
    var botChats: [Chat]
    
}

struct Bot {
    
    //SAVE BOT DATA
    func saveBot(botId:Int, name: String, createdDate: Date, botChats: [Chat])  {
        
        let encoder = PropertyListEncoder()
        do {
            //ENCODE DATA using propertyListEncoder so we can save in userdefaults
            let data = try encoder.encode(botChats)
            let botData = [botIdKey: botId, nameKey: name, createdDateKey: createdDate, botChatsKey: data] as [String : Any?]
           
            UserDefaults.standard.set(botData, forKey: name)
            
        } catch {
            print("Error encoding item array!")
        }
        
        
    }
    
    
    //CLEAR BOT DATA
    static func clearBotData(botName: String){
        UserDefaults.standard.removeObject(forKey: botName)
    }
    
 
    //GET BOT DATA
    var getBot = { (botName: String) -> BotModel? in
        
        let data =  UserDefaults.standard.value(forKey: botName)
        let dict = data as? [String : Any?]
        
        let dictBotChats =  dict?["botChats"] as? Data
        if (dictBotChats == nil){
            return nil
        }
        else {
        let chats = try? PropertyListDecoder().decode([Chat].self , from: dictBotChats!)
        let botmodel: BotModel = BotModel(botId: dict!["botId"] as! Int, name:  dict!["name"] as! String , createdDate:  dict!["createdDate"] as! Date, botChats: chats!)
        
            return botmodel
            
        }
        
    }
    
}
