//
//  MapViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func mapViewControllerPhotos(viewController: MapViewController) -> [PhotoAroundLocation]
}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var delegate: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupAnnotations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "previewImage" {
            if let view = sender as? MKAnnotationView {
                if let annotation = view.annotation as? Annotation {
                    
                    let viewController = segue.destinationViewController as! ImageViewerViewController
                    
                    let photo = annotation.photo
                    viewController.imageUrlString = photo.imageUrl
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helpers
    
    func setupAnnotations() {
        
        if let delegate = delegate {
            
            mapView.removeAnnotations(mapView.annotations)
            
            let photos = delegate.mapViewControllerPhotos(self)
            for photo in photos {
                let annotation = Annotation(photo: photo)
                mapView.addAnnotation(annotation)
            }
            
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let AnnotationIdentifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        }
        
        annotationView?.annotation = annotation
        
        /*
        let nextTag = annotationView!.tag + 1
        annotationView!.tag = nextTag
        
        if let annotation  = annotation as? Annotation {
        
        if let urlString = annotation.photo.imageUrl {
        if let url = NSURL(string: urlString) {
        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .HighPriority, progress: { (_, _) -> Void in
        
        }, completed: { (image, error, _, _, _) -> Void in
        if annotationView?.tag == nextTag {
        annotationView?.image = image
        }
        })
        }
        }
        }
        */
        
        return annotationView;
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegueWithIdentifier("previewImage", sender: view)
    }
}
