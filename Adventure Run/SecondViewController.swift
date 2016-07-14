//
//  SecondViewController.swift
//  Adventure Run
//
//  Created by Maria Sam on 6/9/16.
//  Copyright © 2016 Maria Sam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit
import CoreData

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var stopsLeftText: UITextView!
    
    @IBOutlet var timeLeftText: UITextView!
    var Counter: Int = 0
    var Timer : NSTimer = NSTimer()
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var reachedStopButton: UIButton!
    @IBOutlet var startAdventureButton: UIButton!
    
    var cameUpWithLocations: Bool = false
    var xCoordinates = [Double]()
    var yCoordinates = [Double]()
    var locationX: Double = 0
    var locationY: Double = 0
    
    var stopNumber: Int = 0
    var dropPin = MKPointAnnotation()
    
    var latOriginal = 0.0
    var longOriginal = 0.0
    
    let coordRadius: CGFloat = 0.001
    
    let myView = UIImageView()
    let app = UIApplication.sharedApplication()
    
    var people = [NSManagedObject]()
    var runhistories = [NSManagedObject]()
    
    var distanceTravelled = 0.0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        self.locationManager.activityType = .Fitness
        
        self.locationManager.distanceFilter = 10
        
        self.mapView.showsUserLocation = true
        
        //  reachedStopButton.titleLabel?.shadowColor = UIColor.blackColor()
        
        // reachedStopButton.titleLabel?.shadowOffset = CGSize(width: 0.0, height: -5.0)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        // let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        locationX = location.coordinate.latitude
        locationY = location.coordinate.longitude
        
        
        if !cameUpWithLocations {
            latOriginal = location.coordinate.latitude
            longOriginal = location.coordinate.longitude
            setUpCoordinates(latOriginal, longOriginal: longOriginal)
            
        }
        
        if(reachedLocation(locationX, locY: locationY)) {
            setNotification()
        }
        
        
        //self.locationManager.stopUpdatingLocation()
    }
    
    func reachedLocation(locX: Double, locY: Double) -> Bool {
        if(abs(locX - xCoordinates[stopNumber]) <= 0.001 && abs(locY - yCoordinates[stopNumber]) <= 0.001) {
            return true
        }else{
            return false
        }
    }
    
    func setNotification() {
        
    }
    
    func setUpCoordinates(latOriginal: Double, longOriginal: Double) {
        xCoordinates = comeUpWithLocationsLatitude(latOriginal, longi: longOriginal)
        yCoordinates = comeUpWithLocationsLongitude(latOriginal, longi: longOriginal)
        
       
        
        cameUpWithLocations = true
        
        let center = CLLocationCoordinate2D(latitude: latOriginal, longitude: longOriginal)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func comeUpWithLocationsLatitude(lat: Double, longi: Double) -> Array<Double> {
        
        var latitudeLocations = [Double]()
        var change: Double = 0.0
        
        for _ in 1...5 {
            change = Double(randomBetweenNumbers(-coordRadius, secondNum: coordRadius))
            latitudeLocations.append(lat+change)
        }
        
        return latitudeLocations
        
    }
    
    func comeUpWithLocationsLongitude(lat: Double, longi: Double) -> Array<Double> {
        
        var longitudeLocations = [Double]()
        var change: Double = 0.0
        
        for _ in 1...5 {
            change = Double(randomBetweenNumbers(-coordRadius, secondNum: coordRadius))
            longitudeLocations.append(longi+change)
        }
        
        return longitudeLocations
    }
    
    @IBAction func PlayButton(sender: AnyObject) {
        Timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SecondViewController.UpdateTimer), userInfo: nil, repeats: true)
        
        let customizationAlert = UIAlertController(title: "Customization?", message: "How many miles do you want to run?", preferredStyle: UIAlertControllerStyle.Alert)
        
        customizationAlert.addAction(UIAlertAction(title: "1", style: .Default, handler: { (action: UIAlertAction!) in
            print("1")
        }))
        
        customizationAlert.addAction(UIAlertAction(title: "3", style: .Default, handler: { (action: UIAlertAction!) in
            print("3")
        }))
        
        customizationAlert.addAction(UIAlertAction(title: "Custom", style: .Default, handler: { (action: UIAlertAction!) in
            print("custom")
        }))
        
        presentViewController(customizationAlert, animated: true, completion: nil)
        //self.startOver()
        
        placePins(stopNumber)
    }
    
    func placePins(stopNum: Int) {
        /* let directionRequest: MKDirectionsRequest = MKDirectionsRequest()
         let startLocation: MKPlacemark = MKPlacemark(coordinate: pinLocation, addressDictionary: )
         directionRequest.source = MKMapItem(placemark: startLocation)
         let directions: MKDirections = MKDirections(request: directionRequest)
         //directions.calculateDirectionsWithCompletionHandler(<#T##completionHandler: MKDirectionsHandler##MKDirectionsHandler##(MKDirectionsResponse?, NSError?) -> Void#>)
         */
        
        let pinLocationDist = CLLocation(latitude: xCoordinates[stopNum], longitude: yCoordinates[stopNum])
        
        let pinLocation = CLLocationCoordinate2DMake(xCoordinates[stopNum], yCoordinates[stopNum])
        
        var prevPinLocationDist: CLLocation;
        if(stopNum > 0) {
            prevPinLocationDist = CLLocation(latitude: xCoordinates[stopNum-1], longitude: yCoordinates[stopNum-1])
            distanceTravelled += prevPinLocationDist.distanceFromLocation(pinLocationDist)
        }
        
        dropPin.coordinate = pinLocation
        dropPin.title = "Stop \(stopNum + 1)"
        
        let mapPoint = self.mapView.convertCoordinate(pinLocation, toPointToView: self.mapView)
        myView.frame = CGRect(x: mapPoint.x, y: mapPoint.y, width: 0, height: 0)
        myView.image = UIImage(named: "greentarget")
        self.mapView.addSubview(myView)
        
        let lightCircle = UIImageView()
        lightCircle.frame = CGRect(x: mapPoint.x, y: mapPoint.y, width: 0, height: 0)
        
        lightCircle.image = UIImage(named: "light-green-circle-md")
        lightCircle.alpha = 0.5
        self.mapView.addSubview(lightCircle)
        
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate(timeIntervalSinceNow: 10) // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": "1234", ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        //sleep(10)
        
        //print("before")
        //app.presentLocalNotificationNow(notification)
        app.scheduleLocalNotification(notification)
       
        
        UIView.animateWithDuration(1) {
            self.myView.frame = CGRect (x:(mapPoint.x - 15), y: (mapPoint.y - 15), width: 30, height: 30)
            lightCircle.frame = CGRect(x:(mapPoint.x - 50), y: (mapPoint.y - 50), width: 100, height: 100)
        }
        UIView.animateWithDuration(2) {
            self.myView.frame = CGRect (x:(mapPoint.x - 10), y: (mapPoint.y - 10), width: 20, height: 20)
            lightCircle.frame = CGRect(x: mapPoint.x, y: mapPoint.y, width: 0, height: 0)
            
        }
        
        //self.mapView.addAnnotation(self.dropPin)
        //changeRegion()
        
        
    }
    
    @IBAction func nextStop(sender: AnyObject) {
        if stopNumber == 4 {
            stopNumber = stopNumber + 1
            stopsLeftText.text = "Stops Left: \(5-stopNumber)"
            self.Timer.invalidate()
            
            
            let countMileTime = Double(Counter)
            
            let avgMileTime = (countMileTime/60.0)/(distanceTravelled/1609)
            
            let congratsAlert = UIAlertController(title: "Congratulations!", message: "Your average mile time was \(String(format:"%.02f", avgMileTime)) minutes.", preferredStyle: UIAlertControllerStyle.Alert)
            
            congratsAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("here")
                //Variables.runtimes.append(Runtime(runtime: String(format:"%.02f", avgMileTime) + String(" min/mile."), date: "fdsa"))
                let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                
                let managedContext = appDelegate.managedObjectContext
                
                
                //2
                let entity =  NSEntityDescription.entityForName("RunHistory",
                    inManagedObjectContext:managedContext)
                
                let runhistory = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: managedContext)
                
                //3
                runhistory.setValue(String(format:"%.02f", avgMileTime) + String(" min/mile."), forKey: "runtime")
                
                //4
                do {
                    try managedContext.save()
                    //5
                    self.runhistories.append(runhistory)
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                self.startOver()
                
                
                //self.performSegueWithIdentifier("showruntimes", sender: nil)
            }))
            
            presentViewController(congratsAlert, animated: true, completion: nil)
            
            //print(runhistories)
            
            testCoreData()
            
            //save time
            //reset
        }else if reachedStop() {
            stopNumber = stopNumber + 1
            stopsLeftText.text = "Stops Left: \(5-stopNumber)"
            //mapView.removeAnnotation(dropPin)
            self.myView.removeFromSuperview()
            placePins(stopNumber)
        }else{
            let notThereYetAlert = UIAlertController(title: "Oops!", message: "You're not there yet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            notThereYetAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Not there yet")
            }))
            
            presentViewController(notThereYetAlert, animated: true, completion: nil)
        }
    }
    
    func testCoreData() {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "RunHistory")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            runhistories = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func startOver() {
        mapView.removeAnnotation(dropPin)
        stopsLeftText.text = "Stops Left: 5"
        //cameUpWithLocations = false
        xCoordinates.removeAll()
        yCoordinates.removeAll()
        stopNumber = 0
        timeLeftText.text = "00:00"
        setUpCoordinates(locationX, longOriginal: locationY)
        
    }
    
    func changeRegion() {
        
        let center = CLLocationCoordinate2D(latitude: (locationX+xCoordinates[stopNumber])/2, longitude: (locationY+yCoordinates[stopNumber])/2)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func reachedStop() -> Bool {
        //within .001
        let xCoordDistance = abs(locationX - xCoordinates[stopNumber])
        
        let yCoordDistance = abs(locationY - yCoordinates[stopNumber])
        if xCoordDistance <= 0.001 && yCoordDistance <= 0.001 {
            return true
        }else{
            return false
        }
    }
    
    func UpdateTimer() {
        Counter = Counter + 1
        timeLeftText.text = String(format: "%02d", ((Counter)/60)) + ":" + String(format: "%02d", ((Counter)%60))
    }
    
    /*
     
     @IBAction func PauseButton(sender: AnyObject) {
     Timer.invalidate()
     }
     @IBAction func ResetButton(sender: AnyObject) {
     Timer.invalidate()
     Counter = 0
     TimeLabel.text = String(Counter)
     }
     */
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
}

