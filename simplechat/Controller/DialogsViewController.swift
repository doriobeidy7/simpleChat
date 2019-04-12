//
//  DialogsViewController.swift
//  simplechat
//
//  Created by Dori on 4/10/19.
//  Copyright © 2019 Dori. All rights reserved.
//

import UIKit

class DialogsViewController: UIViewController {
    
   let dialogViewModel = DialogViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        dialogViewModel.delegate = self
        dialogViewModel.getBotList()
    }
}

