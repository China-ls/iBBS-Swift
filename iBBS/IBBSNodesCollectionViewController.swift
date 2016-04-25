//
//  IBBSNodesCollectionViewController.swift
//  iBBS
//
//  Created by Augus on 9/2/15.
//
//  http://iAugus.com
//  https://github.com/iAugux
//
//  Copyright © 2015 iAugus. All rights reserved.
//


import UIKit
import SwiftyJSON
import GearRefreshControl

class IBBSNodesCollectionViewController: UICollectionViewController {
    
    private var gearRefreshControl: GearRefreshControl!
    
    private var nodesArray: [JSON]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IBBSConfigureNodesInfo.sharedInstance.configureNodesInfo()
        nodesArray = IBBSConfigureNodesInfo.sharedInstance.nodesArray
        gearRefreshManager()
        
        collectionView?.addSubview(gearRefreshControl)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.topItem?.title = TITLE_ALL_NODES
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CUSTOM_THEME_COLOR]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateTheme), name: kThemeDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - update theme
    @objc private func updateTheme() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : CUSTOM_THEME_COLOR]
        
        if let cells = collectionView?.visibleCells() as? [IBBSNodesCollectionViewCell] {
            for index in 0 ..< cells.count {
                let cell = cells[index]
                cell.imageView.backgroundColor = CUSTOM_THEME_COLOR.lighterColor(0.75)
                cell.imageView.layer.shadowColor = CUSTOM_THEME_COLOR.darkerColor(0.9).CGColor
                cell.customBackgroundView?.fillColor = CUSTOM_THEME_COLOR.lighterColor(0.8)
                cell.customBackgroundView?.setNeedsDisplay()
            }
        }
        
        gearRefreshControl?.removeFromSuperview()
        gearRefreshManager()
        collectionView?.addSubview(gearRefreshControl)
    }
    
}


extension IBBSNodesCollectionViewController {
    
    // MARK: - Collection view data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nodesArray?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(IBBSNodesCollectionViewCell), forIndexPath: indexPath) as? IBBSNodesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // nodesArray = IBBSConfigureNodesInfo.sharedInstance.nodesArray
        if let array = nodesArray {
            let json = array[indexPath.row]
            cell.infoLabel?.text = json["name"].stringValue
        }
        
        return cell
    }
    
    
    // MARK: - Collection view delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let array = nodesArray else { return }
        guard let vc = MainStoryboard.instantiateViewControllerWithIdentifier(String(IBBSNodeViewController)) as? IBBSNodeViewController else { return }
        
        let json = array[indexPath.row]
        vc.nodeJSON = json
        whoCalledEditingViewController = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension IBBSNodesCollectionViewController {
    
    // MARK: - perform GearRefreshControl
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        gearRefreshControl?.scrollViewDidScroll(scrollView)
        
        executeAfterDelay(3) {
            self.gearRefreshControl?.endRefreshing()
        }
    }
    
    private func gearRefreshManager() {
        
        gearRefreshControl = GearRefreshControl(frame: view.bounds)
        gearRefreshControl.gearTintColor = CUSTOM_THEME_COLOR.lighterColor(0.7)
        
        gearRefreshControl.addTarget(self, action: #selector(refreshData), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @objc private func refreshData() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            IBBSConfigureNodesInfo.sharedInstance.configureNodesInfo()
            self.nodesArray = IBBSConfigureNodesInfo.sharedInstance.nodesArray
            
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView?.reloadData()
            })
        })
    }
    
}


public class IBBSConfigureNodesInfo {
    
    static let sharedInstance = IBBSConfigureNodesInfo()
    
    public var nodesArray: [JSON]?
    
    public func configureNodesInfo() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.getNodesIfNeeded()
            
            let nodes = IBBSContext.sharedInstance.getNodes()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let json = nodes {
                    self.nodesArray = json.arrayValue
                } else {
                    self.configureNodesInfo()
                }
            })
        })
    }
    
    private func getNodesIfNeeded() {
        
        APIClient.sharedInstance.getNodes({ (json) -> Void in
            
            guard json.type == Type.Array else { return }
            
            self.nodesArray = json.arrayValue
            debugPrint(json.arrayValue)
            IBBSContext.sharedInstance.saveNodes(json.object)
            
        }) { (error) -> Void in
            IBBSToast.make(SERVER_ERROR, interval: TIME_OF_TOAST_OF_SERVER_ERROR)
        }
    }
}
