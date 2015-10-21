//
//  WorkflowStateCell.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/17/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class WorkflowStateCell : SDataGridCell {
    private var _state: WorkflowState!
    private var _parentType: ObjectType!
    private var _imageView: UIImage = UIImage()
    var image: UIImage!

    var state: WorkflowState! {
        get {
            return _state
        }
        set(val) {
            self.image = UIImage(named: val.imageName)
            let imageView = UIImageView(image: image)
            imageView.sizeToFit()
            imageView.frame = CGRectMake(10, 3, image.size.width-5, image.size.height-5)
            self.addSubview(imageView)
            _state = val
        }
    }
    
    var parentType: ObjectType! {
        get {
            return _parentType
        }
        set(val) {
            self.image = UIImage(named: val.imageName)
            let imageView = UIImageView(image: image)
            imageView.sizeToFit()
            imageView.frame = CGRectMake(10, 3, image.size.width-5, image.size.height-5)
            self.addSubview(imageView)
            _parentType = val
        }
    }
    
    

    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init!(reuseIdentifier identifier: String!) {
        super.init(reuseIdentifier: identifier)
    }
}
