//
//  TiledScrollView.swift
//  e-motion
//
//  Created by mohamed mohamed El Dehairy on 3/20/15.
//  Copyright (c) 2015 mohamed mohamed El Dehairy. All rights reserved.
//

import UIKit

class LinkedListNode<T>
{
    var object   : T;
    var nextNode : LinkedListNode<T>?;
    var preNode  : LinkedListNode<T>?;
    
    init(object : T)
    {
        self.object = object;
    }
}

class LinkedList<T> : Sequence
{
    fileprivate var head : LinkedListNode<T>?;
    fileprivate var tail : LinkedListNode<T>?;
    
    fileprivate var iteratorCurrentObject : LinkedListNode<T>?;
    
    var count : Int;
    
    init()
    {
        count = 0;
    }
    
    func getTail()->T?
    {
        return tail?.object;
    }
    
    func getHead()->T?
    {
        return head?.object;
    }
    
    func appendObjectToTail(_ object : T)
    {
        let newNode = LinkedListNode<T>(object: object);
        
        if (tail == nil)
        {
            head = newNode;
            tail = newNode;
        }
        else
        {
            tail?.nextNode  = newNode;
            newNode.preNode = tail;
            tail            = newNode;
        }
        
        count += 1;
    }
    
    func appendObjectToHead(_ object : T)
    {
        let newNode = LinkedListNode<T>(object: object);
        
        if (head == nil)
        {
            head = newNode;
            tail = newNode;
        }
        else
        {
            newNode.nextNode = head;
            head?.preNode    = newNode;
            head             = newNode;
        }
        
        count += 1;
    }
    
    func removeFromHead()->T?
    {
        let object = head?.object;
        
        head?.nextNode?.preNode = nil;
        
        head = head?.nextNode;
        
        count -= 1;
        
        return object;
    }
    
    func removeFromTail()->T?
    {
        let object = tail?.object;
        
        tail?.preNode?.nextNode = nil;
        
        tail = tail?.preNode;
        
        count -= 1;
        
        return object;
    }
    
    func makeIterator() -> AnyIterator<T>
    {
        iteratorCurrentObject = nil;
        
        return AnyIterator{
            
            if (self.iteratorCurrentObject == nil)
            {
                self.iteratorCurrentObject = self.head;
            }
            else
            {
                self.iteratorCurrentObject = self.iteratorCurrentObject?.nextNode;
            }
            
            return self.iteratorCurrentObject?.object;
            
        }
    }
    
}

@objc protocol TiledScrollViewDelegate : class
{
    /**
     Ask the delegate for the view to be used as a tile at specific x index (from left to right) , and y index (from top to bottom)
     
     - parameter xIndex: x index of tile (from left to right)
     - parameter yIndex: y index of tile (from top to bottom)
     - parameter frame:  the frame of the tile
     
     - returns: returns the tile view at the specified xIndex , and yIndex
     */
    func tileForTiledScrollView(_ tiledScrollView : TiledScrollView,xIndex : Int , yIndex : Int , frame : CGRect)-> TileView
    
    func tileMoving(_ xIndex : Int , yIndex : Int)
}

@objc open class TiledScrollView: UIScrollView, UIGestureRecognizerDelegate
{
    //matrix of currently visible views
    fileprivate var visibleViews: LinkedList<LinkedList<UIView>> = LinkedList<LinkedList<UIView>>()
    
    open var containerView: UIView!
    
    fileprivate var tileSize: CGSize!
    
    fileprivate var scale_ipad: CGFloat = 1.0
    
    //tiling delegate
    weak var tilingDelegate : TiledScrollViewDelegate?;
    
    init(frame: CGRect , contentSize : CGSize , tiledDelegate : TiledScrollViewDelegate? , tileSize : CGSize)
    {
        super.init(frame: frame)
        
        self.contentSize = contentSize
        
        //initialise the tiling delegate
        self.tilingDelegate = tiledDelegate
        
        //initialise the tile size
        self.tileSize = tileSize
        
        //initialise th UI
        self.initialiseUI(frame)
    }
    
    convenience override init(frame: CGRect)
    {
        self.init(frame: frame , contentSize : frame.size , tiledDelegate : nil , tileSize: frame.size)
        
        self.initialiseUI(frame)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.initialiseUI(self.frame)
    }
    
    fileprivate func initialiseUI(_ frame : CGRect)
    {
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.backgroundColor = UIColor.black
        self.scrollsToTop = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.bouncesZoom = false
        
        self.minimumZoomScale = 0.5
        self.maximumZoomScale = 1.0
        self.zoomScale = 1.0
        
        self.delaysContentTouches = true
        self.canCancelContentTouches = false
        self.isUserInteractionEnabled = true
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            scale_ipad = 2.0
        }
        
        //initialise the tiles container view
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containerView.isUserInteractionEnabled = true
        containerView.backgroundColor = UIColor.black
        self.addSubview(containerView)
        
        //initialise the visible views matrix
        visibleViews.appendObjectToHead(LinkedList<UIView>())
        
        //create the top left tile view at (0,0)
        let newView = self.createView(CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height) , xIndex : 0 , yIndex : 0)
        visibleViews.getTail()?.appendObjectToTail(newView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TiledScrollView.drawMarchingLine(_:)),
            name: NSNotification.Name(rawValue: "DrawMarchingLine"),
            object: nil)
    }
    
    @objc open func tile_tag_make( _ col: Int, row: Int)-> Int
    {
        let TILE_MAX_ROW_CAPACITY = 1000
        return ((col+1)*TILE_MAX_ROW_CAPACITY+(row+1))
    }
    
    fileprivate func createView( _ frame : CGRect , xIndex : Int , yIndex : Int)-> UIView
    {
        if (tilingDelegate != nil && containerView != nil)
        {
            let tileView: TileView = tilingDelegate!.tileForTiledScrollView(self, xIndex: xIndex , yIndex: yIndex , frame : frame)
            tileView.frame = frame
            
            self.containerView.addSubview(tileView)
            
            let tile_tag = self.tile_tag_make(xIndex, row: yIndex)
            
            if tileView.strLabel != "0"
            {
                let label_height: CGFloat = 15.0*scale_ipad
                let label_spacing: CGFloat = 15.0*scale_ipad
                var label_x: CGFloat = frame.origin.x - label_spacing
                let label_y: CGFloat = frame.origin.y + frame.size.height
                var label_width: CGFloat = frame.size.width + label_spacing*2
                
                if tileView.strLabel == "Village"
                {
                    label_x = frame.origin.x
                    label_width = frame.size.width
                }
                
                let label = UILabel(frame: CGRect(x: label_x, y: label_y, width: label_width, height: label_height))
                label.numberOfLines = 1
                label.textAlignment = NSTextAlignment.center
                label.font = UIFont (name: DEFAULT_FONT_BOLD, size: 8*scale_ipad)
                label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                label.minimumScaleFactor = 0.1
                label.text = tileView.strLabel
                
                if tileView.tile_content == TILE_CITY_ENEMY
                {
                    label.textColor = UIColor.salmon()
                }
                else if tileView.tile_content == TILE_VILLAGE
                {
                    label.textColor = UIColor.tomato()
                }
                else
                {
                    label.textColor = UIColor.robinEgg()
                }
                
                label.layer.zPosition = CGFloat(MAXFLOAT)
                label.tag = tile_tag
                
                //Remove all labels with same tag
                for view in containerView.subviews
                {
                    if view.isKind(of: UILabel.self)
                    {
                        if view.tag == tile_tag
                        {
                            view.removeFromSuperview()
                        }
                    }
                }
                
                self.containerView.addSubview(label)
            }
            else
            {
                //Remove all labels with same tag
                for view in containerView.subviews
                {
                    if view.isKind(of: UILabel.self)
                    {
                        if view.tag == tile_tag
                        {
                            view.removeFromSuperview()
                        }
                    }
                }
            }
            
            return tileView;
        }
        else
        {
            return UIView(frame: frame)
        }
    }
    
    @objc open func notificationsRemove()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc open func drawMarchingLine(_ notification: Notification)
    {
        print("drawMarchingLine");
        let map_x: String = Globals.i().wsBaseDict["map_x"] as! String
        let map_y: String = Globals.i().wsBaseDict["map_y"] as! String
        
        let xIndex: Int = Int(map_x)!
        let yIndex: Int = Int(map_y)!
        
        let container_x: CGFloat = CGFloat(xIndex) * tileSize.width
        let container_y: CGFloat = CGFloat(yIndex) * tileSize.height
        
        let line_height: CGFloat = 24*scale_ipad
        let line_x = container_x + (tileSize.width/2)
        let line_y = container_y + (tileSize.height/2) - (line_height/2)
        
        var user_info: Dictionary = notification.userInfo as Dictionary!
        let tv_id: String = user_info["tv_id"] as! String
        let to_x: String = user_info["to_x"] as! String
        let to_y: String = user_info["to_y"] as! String
        
        let int_tv_id: Int = Int(tv_id)!
        let to_xIndex: Int = Int(to_x)!
        let to_yIndex: Int = Int(to_y)!
        
        let container_to_x: CGFloat = CGFloat(to_xIndex) * tileSize.width
        let container_to_y: CGFloat = CGFloat(to_yIndex) * tileSize.height
        
        let line_width: CGFloat = Globals.i().distance2xy(container_x, container_y, container_to_x, container_to_y)
        
        let home_point: CGPoint = CGPoint(x: container_x, y: container_y)
        let to_point: CGPoint = CGPoint(x: container_to_x, y: container_to_y)
        
        let radians: CGFloat = Globals.i().pointPair(toBearingRadians: home_point, secondPoint: to_point)
        
        if Globals.i().isThereTvView(int_tv_id)
        {
            let idLine: MarchingLine = MarchingLine(frame: CGRect(x: line_x, y: line_y, width: line_width, height: line_height))
            idLine.layer.zPosition = CGFloat(MAXFLOAT)
            
            idLine.timerView = Globals.i().copyTvView(fromStack: int_tv_id)
            
            setAnchorPoint(CGPoint(x: 0.0, y: 0.5), forView: idLine)
            idLine.transform = CGAffineTransform(rotationAngle: radians)
            idLine.angle = radians
            
            self.containerView.addSubview(idLine)
            idLine.updateView()
        }
    }
    
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView)
    {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    func drawVisibleMap()
    {
        let boundRect = self.convert(self.bounds, to:self.containerView)
        
        // add/remove tiles horizontall*****************************************************
        for array in visibleViews
        {
            autoreleasepool(invoking: {
                
                //add views at the bottom
                var view : UIView! = array.getTail()!
                var maxY = view.frame.maxY
                
                while maxY < boundRect.maxY
                {
                    autoreleasepool(invoking: {
                        let yPosition = view.frame.origin.y + view.frame.size.height
                        let xPosition = view.frame.origin.x
                        
                        let newView = self.createView(CGRect(x: xPosition, y: yPosition , width: self.tileSize.width, height: self.tileSize.height) , xIndex : Int(CGFloat(xPosition) / view.frame.size.width) ,yIndex : Int(CGFloat(yPosition) / view.frame.size.height))
                        
                        array.appendObjectToTail(newView)
                        
                        view = array.getTail()!
                        maxY = view.frame.maxY
                    })
                }
                
                //add views at the top
                view = array.getHead()!
                var minY: CGFloat = 0.0
                
                if (view != nil)
                {
                    minY = view.frame.minY
                }
                
                while minY > boundRect.minY
                {
                    autoreleasepool(invoking: {
                        
                        let yPosition = view.frame.origin.y - view.frame.size.height
                        let xPosition = view.frame.origin.x
                        
                        let newView = self.createView(CGRect(x: xPosition, y: yPosition , width: self.tileSize.width, height: self.tileSize.height) , xIndex : Int(CGFloat(xPosition) / view.frame.size.width) , yIndex : Int(CGFloat(yPosition) / view.frame.size.height))
                        
                        array.appendObjectToHead(newView)
                        
                        view = array.getHead()!
                        minY = view.frame.minY
                        
                    })
                    
                }
                
                //remove views that has fallen beyond the bottom edge
                view = array.getTail()
                
                if (view != nil)
                {
                    minY = view.frame.minY
                }
                
                while minY > boundRect.maxY
                {
                    autoreleasepool(invoking: {
                        
                        view.removeFromSuperview()
                        array.removeFromTail()
                        
                        view = array.getTail()
                        minY = view.frame.minY
                        
                    })
                    
                }
                
                //remove views that has fallen beyond the top edge
                view = array.getHead()
                
                if (view != nil)
                {
                    maxY = view.frame.maxY
                }
                
                while maxY < boundRect.minY
                {
                    autoreleasepool(invoking: {
                        view.removeFromSuperview()
                        array.removeFromHead()
                        
                        view = array.getHead()
                        maxY = view.frame.maxY
                        
                    })
                    
                }
                
            })
            
        }
        
        // add/remove tiles vertically*****************************************************
        
        //add views at the right
        var view2 = visibleViews.getTail()!.getHead()!
        var maxX = view2.frame.maxX
        
        while maxX < boundRect.maxX
        {
            autoreleasepool(invoking: {
                
                let newArray = LinkedList<UIView>()
                if let visibleViewTailCount = self.visibleViews.getTail()?.count
                {
                    for index in (0..<visibleViewTailCount)
                    {
                        autoreleasepool(invoking: {
                            let xPosition = view2.frame.origin.x + view2.frame.size.width
                            let yPosition = view2.frame.origin.y + CGFloat(index) * view2.frame.size.height
                            
                            let newView = self.createView(CGRect(x: xPosition , y: yPosition, width: self.tileSize.width, height: self.tileSize.height) , xIndex : Int(CGFloat(xPosition) / view2.frame.size.width) , yIndex : Int(CGFloat(yPosition) / view2.frame.size.height))
                            
                            newArray.appendObjectToTail(newView)
                        });
                        
                    }
                }
                self.visibleViews.appendObjectToTail(newArray)
                
                view2 = self.visibleViews.getTail()!.getHead()!
                maxX = view2.frame.maxX
                
            });
            
        }
        
        //add views at the left
        var view1 : UIView! = visibleViews.getHead()?.getHead()
        var minX: CGFloat = 0.0
        
        if (view1 != nil)
        {
            minX = view1.frame.minX
        }
        
        while minX > boundRect.minX
        {
            autoreleasepool(invoking: {
                let newArray = LinkedList<UIView>()
                if let visibleViewHeadCount = self.visibleViews.getHead()?.count
                {
                    for index in (0..<visibleViewHeadCount)
                    {
                        autoreleasepool(invoking: {
                            
                            let xPosition = view1.frame.origin.x - view1.frame.size.width
                            let yPosition = view1.frame.origin.y + CGFloat(index) * view1.frame.size.height
                            
                            let newView = self.createView(CGRect(x: xPosition, y: yPosition, width: self.tileSize.width, height: self.tileSize.height) , xIndex : Int(CGFloat(xPosition) / view2.frame.size.width) , yIndex : Int(CGFloat(yPosition) / view1.frame.size.height))
                            
                            newArray.appendObjectToTail(newView)
                            
                        });
                    }
                }
                self.visibleViews.appendObjectToHead(newArray)
                
                view1 = self.visibleViews.getHead()?.getHead()
                minX = view1.frame.minX
            })
            
        }
        
        //remove views that has fallen beyond the right edge
        view2 = visibleViews.getTail()!.getHead()!
        minX = view2.frame.minX
        
        while minX > boundRect.maxX
        {
            autoreleasepool(invoking: {
                
                for view in self.visibleViews.getTail()!
                {
                    view.removeFromSuperview()
                }
                
                self.visibleViews.removeFromTail()
                
                view2 = self.visibleViews.getTail()!.getHead()!
                minX = view2.frame.minX
            })
            
        }
        
        //remove views that has fallen beyond the left edge
        view1 = visibleViews.getHead()!.getHead()!
        if (view1 != nil)
        {
            maxX = view1.frame.maxX
        }
        
        while maxX < boundRect.minX
        {
            autoreleasepool(invoking: {
                for view in self.visibleViews.getHead()!
                {
                    view.removeFromSuperview()
                }
                
                self.visibleViews.removeFromHead()
                
                view1 = self.visibleViews.getHead()!.getHead()!
                maxX = view1.frame.maxX
            })
            
        }
        
        let view : UIView! = visibleViews.getHead()?.getHead()
        let moveX:Int = Int(view.frame.origin.x)
        let moveY:Int = Int(view.frame.origin.y)
        
        //TODO: flick very fast to the left right after load map will crash here
        if (tilingDelegate != nil && view != nil)
        {
            tilingDelegate!.tileMoving(moveX, yIndex: moveY)
        }
    }
    
    @objc open func refreshVisibleMap()
    {
        DispatchQueue.main.async
        {
            self.visibleViews = LinkedList<LinkedList<UIView>>()
            
            //initialise the visible views matrix
            self.visibleViews.appendObjectToHead(LinkedList<UIView>())
            
            //create the top left tile view at (0,0)
            let newView = self.createView(CGRect(x: 0, y: 0, width: self.tileSize.width, height: self.tileSize.height) , xIndex : 0 , yIndex : 0)
            self.visibleViews.getTail()?.appendObjectToTail(newView)
            
            self.containerView.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
            
            self.containerView.removeFromSuperview()
            
            self.drawVisibleMap()
            
            self.addSubview(self.containerView)
            
            self.containerView.subviews.forEach { $0.setNeedsDisplay() }
            self.containerView.setNeedsDisplay()
            self.setNeedsDisplay()
        }
    }
    
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.drawVisibleMap()
    }
}
