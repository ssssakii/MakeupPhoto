//
//  StampViewController.swift
//  MakeupPhoto
//
//  Created by SAKI TAKADA on 2017/09/30.
//  Copyright © 2017年 saki takada. All rights reserved.
//

import UIKit


class StampViewController: UIViewController {
    
    var imageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pushButton(_ sender: UIButton) {
        print("スタンプを選択したよー！！")
        
        switch sender.tag {
        case 1:
            imageIndex = 1
            break
        case 2:
            imageIndex = 2
            break
        case 3:
            imageIndex = 3
            break
        case 4:
            imageIndex = 4
            break
        case 5:
            imageIndex = 5
            break
        case 6:
            imageIndex = 6
            break
        case 7:
            imageIndex = 7
            break
        case 8:
            imageIndex = 8
            break
        case 9:
            imageIndex = 9
            break
        case 10:
            imageIndex = 10
            break
        case 11:
            imageIndex = 11
            break
        case 12:
            imageIndex = 12
            break
        case 13:
            imageIndex = 13
            break
        case 14:
            imageIndex = 14
            break
        case 15:
            imageIndex = 15
            break
        case 16:
            imageIndex = 16
            break
        case 17:
            imageIndex = 17
            break
        case 18:
            imageIndex = 18
            break
        default :
            imageIndex = 0
            break
        }
        
        
        //self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "toPhotoVC", sender: nil)
    }
    
    override func prepare(for segue : UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toPhotoVC" {
            print("_____________________deadLine________________________")
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.imageIndex = self.imageIndex
        }
    }
    
}
