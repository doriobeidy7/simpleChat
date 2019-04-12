//
//  NewDialogController.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit

class NewDialogViewController: UIViewController {
    
    let dialogViewModel = DialogViewModel()
    @IBOutlet weak var botNameTfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        cancelViewController()
    }
    
    @IBAction func newBottBtn(_ sender: UIButton) {
        
        createNewBot()
        cancelViewController()
    
    }
    
    func cancelViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func createNewBot()  {
        let randomInt = Int.random(in: 0..<10000)

        let botName = botNameTfield?.text
        dialogViewModel.createNewBot(botId: randomInt, botName: botName!, botDate: Date())
    }
    
}
