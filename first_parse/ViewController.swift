//
//  ViewController.swift
//  first_parse
//
//  Created by D7703_14 on 2017. 10. 25..
//  Copyright © 2017년 D7703_14. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,XMLParserDelegate,MKMapViewDelegate {
    var record:[String:String] = [:]
    var records:[[String:String]] = []
    
    @IBOutlet weak var minMap: MKMapView!
    var currentElement = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        minMap.delegate = self
        if let path = Bundle.main.url(forResource: "전국지정약수터표준데이터", withExtension: "xml") {
            
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                //print(path)
                
                if parser.parse() {
                    print("parsing success!")
                    print(records)
                } else {
                    print("parsing failed!!")
                }
            }
        } else {
            print("xml file not found!!")
        }
        
        var annotations = [MKPointAnnotation]()
                    
            for item in records{
                let lat = (item as AnyObject).value(forKey: "위도")
                let long = (item as AnyObject).value(forKey: "경도")
                let title = (item as AnyObject).value(forKey: "약수터명")
                let subTitle = (item as AnyObject).value(forKey: "수질검사결과구분")
                
                
                
                let myLat = (lat as! NSString).doubleValue
                let myLong = (long as! NSString).doubleValue
                let myTitle = title as! String
                let mySubTitle = subTitle as! String
                let annotation = MKPointAnnotation()
                
                annotation.coordinate.latitude = myLat
                annotation.coordinate.longitude = myLong
                annotation.title = myTitle
                annotation.subtitle = mySubTitle
                
                annotations.append(annotation)
                
        }
            
        
        
        minMap.showAnnotations(annotations, animated: true)
        minMap.addAnnotations(annotations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func zoomToRegion(){
        let center = CLLocationCoordinate2D(latitude: 35.166197, longitude: 129.072594)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(center, span)
        
        minMap.setRegion(region, animated: true)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        //print("elementName = \(elementName)")
        
        currentElement = elementName
        
        if elementName == "record" {
            record = [:]
        } else if elementName == "records" {
            records = []
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //print("data =  \(data)")
        if !data.isEmpty {
            record[currentElement] = string
            
            //print("currentElement = \(currentElement)")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "record" {
            records.append(record)
            //print("record = \(record)")
            //print("records = \(records)")
        }
    }
}

