//
//  PhotosViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/5/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SafariServices

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PhotoViewCellDelegate, MapViewControllerDelegate {
    
    var photos = [GenericPhoto]()
    var location: [String: AnyObject]?
    
    var loadMoreLoadingView: UIActivityIndicatorView?
    var loadingView: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    var isLoading = false
    
    var imageViewerVC: ImageViewerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.addTarget(self, action: #selector(PhotosViewController.refresh(_:)), forControlEvents: .ValueChanged)
        collectionView?.addSubview(loadingView)
        
        if location == nil {
            navigationItem.rightBarButtonItem = nil
            
            loadLocalPhotos()
            
            loadingView.beginRefreshing()
            loadRemotePhotos()
        }
        else {
            
            loadLocalPhotosAroundLocation()
            
            loadingView.beginRefreshing()
            loadRemotePhotosAroundLocation()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "previewImage" {
            if let cell = sender as? UICollectionViewCell {
                if let indexPath = collectionView?.indexPathForCell(cell) {
                    
                    imageViewerVC = segue.destinationViewController as? ImageViewerViewController
                    
                    let photo = photos[indexPath.item]
                    imageViewerVC?.imageUrlString = photo.imageUrl
                    imageViewerVC?.photosVC = self
                }
            }
        }
        else if segue.identifier == "presentMap" {
            
            let navController = segue.destinationViewController as! UINavigationController
            let viewController = navController.viewControllers.first as! MapViewController
            viewController.delegate = self
        }
    }
    
    // MARK: - Helpers
    
    func loadLocalPhotos() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        photos = Photo.photosInManagedObjectContext(moc)
    }
    
    func loadRemotePhotos(more: Bool = false) {
        
        if isLoading {
            return
        }
        
        isLoading = true
        if more { loadMoreLoadingView?.startAnimating() }
        
        var maxId: String?
        if more { maxId = photos.last?.photoId }
        
        Engine.shared.myFeed(maxId) { (result, error) -> () in
            
            self.isLoading = false
            self.loadingView.endRefreshing()
            self.loadMoreLoadingView?.stopAnimating()
            
            if let response = result as? [Photo] {
                
                if !more { self.photos = response }
                else { self.photos = self.photos + response }
                
                self.collectionView?.reloadData()
            }
            else if let _ = error {
                
            }
            else {
                
            }
        }
    }
    
    func loadLocalPhotosAroundLocation() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        var locationId = ""
        if let id = location?["id"] as? String { locationId = id }
        
        photos = PhotoAroundLocation.photosWithLocation(locationId, inManagedObjectContext: moc)
    }
    
    func loadRemotePhotosAroundLocation(more: Bool = false) {
        
        if isLoading {
            return
        }
        
        isLoading = true
        if more { loadMoreLoadingView?.startAnimating() }
        
        var locationId = ""
        if let id = location?["id"] as? String { locationId = id }
        
        var maxId: String?
        if more { maxId = photos.last?.photoId }
        
        Engine.shared.photosAroundLocation(locationId, maxId: maxId) { (result, error) -> () in
            
            self.isLoading = false
            self.loadingView.endRefreshing()
            self.loadMoreLoadingView?.stopAnimating()
            
            if let response = result as? [PhotoAroundLocation] {
                
                if !more { self.photos = response }
                else { self.photos = self.photos + response }
                
                self.collectionView?.reloadData()
            }
            else if let _ = error {
                
            }
            else {
                
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToPhotosViewController(segue: UIStoryboardSegue) { }
    
    func refresh(sender: UIRefreshControl) {
        
        if !isLoading {
            if location == nil {
                loadRemotePhotos()
            }
            else {
                loadRemotePhotosAroundLocation()
            }
        }
        else {
            sender.endRefreshing()
        }
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCellId", forIndexPath: indexPath) as! PhotoViewCell
        let nextTag = cell.tag + 1
        cell.tag = nextTag
        
        let photo = photos[indexPath.row]
        cell.nameLabel.text = photo.user?.fullName
        cell.dateLabel.text = photo.createdTime?.timeAgoString()
        cell.captionLabel.text = photo.caption
        
        cell.profileImageView.image = nil
        if let profilePicture = photo.user?.profilePicture {
            if let url = NSURL(string: profilePicture) {
                
                Engine.shared.downloadImageWithUrl(url, completion: { (result, error) -> () in
                    if cell.tag == nextTag {
                        cell.profileImageView.image = result as? UIImage
                    }
                })
            }
        }
        
        cell.photoImageView.image = nil
        cell.activityIndicatorView.stopAnimating()
        if let imageUrl = photo.imageUrl {
            if let url = NSURL(string: imageUrl) {
                
                cell.activityIndicatorView.startAnimating()
                Engine.shared.downloadImageWithUrl(url, completion: { (result, error) -> () in
                    if cell.tag == nextTag {
                        cell.activityIndicatorView.stopAnimating()
                        cell.photoImageView.image = result as? UIImage
                    }
                })
            }
        }
        
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("previewImage", sender: collectionView.cellForItemAtIndexPath(indexPath))
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "LoadMoreViewId", forIndexPath: indexPath)
        
        if let loadingView = view.viewWithTag(999) as? UIActivityIndicatorView {
            loadMoreLoadingView = loadingView
        }
        
        return view
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        var height = CGFloat(70) + width
        
        let photo = photos[indexPath.item]
        
        if let caption = photo.caption {
            let rect = caption.boundingRectWithSize(CGSize(width: width - 20, height: CGFloat.max),
                font: UIFont(name: "AvenirNext-UltraLight", size: 15)!)
            height += rect.height
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView.contentSize.height >= scrollView.bounds.height {
            if scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.height) <= 44 {
                
                if location == nil {
                    loadRemotePhotos(true)
                }
                else {
                    loadRemotePhotosAroundLocation(true)
                }
            }
        }
    }
    
    // MARK: - PhotoViewCellDelegate
    
    func photoViewCellOpenLink(cell: PhotoViewCell) {
        
        if let indexPath = collectionView?.indexPathForCell(cell) {
            let photo = photos[indexPath.row]
            
            if let link = photo.link {
                if let url = NSURL(string: link) {
                    
                    let browser = SFSafariViewController(URL: url)
                    presentViewController(browser, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - MapViewControllerDelegate
    
    func mapViewControllerPhotos(viewController: MapViewController) -> [PhotoAroundLocation] {
        return photos as! [PhotoAroundLocation]
    }
}


















