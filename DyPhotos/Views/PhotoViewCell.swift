//
//  PhotoViewCell.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/5/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

protocol PhotoViewCellDelegate {
    func photoViewCellOpenLink(cell: PhotoViewCell)
}

class PhotoViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var delegate: PhotoViewCellDelegate?
    
    override func awakeFromNib() {
        setupViews()
    }
    
    func setupViews() {
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        linkButton.layer.cornerRadius = 5.0
        linkButton.layer.masksToBounds = true
    }
    
    @IBAction func linkButtonTapped(sender: UIButton) {
        if let delegate = delegate {
            delegate.photoViewCellOpenLink(self)
        }
    }
}
