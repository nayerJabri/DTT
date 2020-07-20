//
//  AboutViewController.swift
//  DTT
//
//  Created by Nayer Jabri on 6/22/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var linkDTT: UITextView!
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0)
        super.viewDidLoad()
        // Do view setup here.
        goTo()
        
    }
    
    func goTo(){
        // on click
        let linkedText = NSMutableAttributedString(attributedString: linkDTT.attributedText)
        let hyperlinked = linkedText.setAsLink(textToFind: "d-tt.nl", linkURL: "https://www.d-tt.nl/")
                
        if hyperlinked {
              linkDTT.attributedText = NSAttributedString(attributedString: linkedText)
        }
    }
    
}
