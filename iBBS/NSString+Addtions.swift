//
//  NSString+Addtions.swift
//  iBBS
//
//  Created by Augus on 9/5/15.
//  Copyright © 2015 iAugus. All rights reserved.
//

import Foundation

extension NSString{
    func ausCalculateSize(size: CGSize, font: UIFont) -> CGSize {
        var expectedLabelSize: CGSize = CGSizeZero
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        let attributes: [String : AnyObject] = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle.copy()]
        expectedLabelSize = self.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height))
    }
    
    
    
    /**
    *  delete trailing "<br>" for string
    */
    class func ausStringByTrimmingCharactersDeleteTrailingBlank(string: String) -> NSString {
        var str = string
        str = str.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<br>"))
        return str
    }

    
}

