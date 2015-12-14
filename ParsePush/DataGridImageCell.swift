//
//  WorkflowStateCell.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/17/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

/* this should be changed to a protocol because the only thing that matters is the displayImage */
class DataGridImageCell : SDataGridCell {
    private var _state: WorkflowState!
    private var _parentType: ObjectType!
    private var _documentType: DocumentType!
    private var _imageView: UIImageView!

    var imageView: UIImageView {
        get {
            if (_imageView == nil) {
                _imageView = UIImageView()
                self.addSubview(_imageView)
            }
            return _imageView
        }
    }

    var state: WorkflowState! {
        get {
            return _state
        }
        set(val) {
            setImage(val.imageName)
            _state = val
        }
    }
    
    var parentType: ObjectType! {
        get {
            return _parentType
        }
        set(val) {
            setImage(val.imageName)
            _parentType = val
        }
    }
    
    var documentType: DocumentType! {
        get {
            return _documentType
        }
        set(val) {
            setImage(val.imageName)
            _documentType = val
        }
    }
    
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName)!
        self.imageView.image = image
        self.imageView.sizeToFit()
        self.imageView.frame = CGRectMake(10, 3, image.size.width-5, image.size.height-5)
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
