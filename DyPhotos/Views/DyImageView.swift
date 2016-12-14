//
//  DyImageView.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/17/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

protocol DyImageViewDelegate: NSObjectProtocol {
    func foo(imageView: DyImageView)
}

class DyImageView: UIImageView {
    var delegate: DyImageViewDelegate?
}
