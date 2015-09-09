//
//  UILabel+Additions.swift
//  iBBS
//
//  Created by Augus on 9/8/15.
//  Copyright © 2015 iAugus. All rights reserved.
//

import Foundation

extension UILabel {
    
    /**
    Methods to allow using HTML code with CoreText
    
    */
    func ausAttributedText(data: String) {
        do {
            let formatedData = data.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let text = try NSAttributedString(data: formatedData.dataUsingEncoding(NSUnicodeStringEncoding,allowLossyConversion: false)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.attributedText = text
        }catch{
            print("something error with NSAttributedString")
        }
    }
}