#ALERT
func displayAlert(let title:String, let message:String){
    if objc_getClass("UIAlertController") != nil {
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style:.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }else{
        let alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
}

#HTTP JSON REQUEST
let post:NSString = "username=\(username)&password=\(password)"
NSLog("Post data: %@", post)
let url:NSURL = NSURL(string: "http://localhost/mobile/ios_latihan/jsonlogin2.php")!
let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
let postLength:NSString = String( postData.length )
let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)

request.HTTPMethod = "POST"
request.HTTPBody = postData
request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
request.setValue("application/json", forHTTPHeaderField: "Accept")

#HTTP JSON RESPONSE
var response:NSURLResponse?
do{
    let urlData:NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
    if (urlData != nil){
        let res = response as! NSHTTPURLResponse!
        NSLog("Response code : %ld", res.statusCode)
        
        if(res.statusCode >= 200 && res.statusCode < 300){
            let responseData:NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData)
            
            do{
                let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                NSLog("Success: %ld", success)
                
                if(success == 1){
                    self.displayAlert("Signin Success", message: "Welcome!")
                } else{
                    var error_msg:NSString
                    
                    if(jsonData["error_message"] as? NSString != nil){
                        error_msg = jsonData["error_message"] as! NSString
                    } else{
                        error_msg = "Unknown Error"
                    }
                    self.displayAlert("Signin Failde", message: error_msg as String)
                }
                
            }catch(let e){
                print(e)
            }
        } else {
            self.displayAlert("Signin Failed!", message: "Connection Failed!")
        }
    } else{
        self.displayAlert("Signin Failed!", message: "Connection Failure!")
    }
    
}catch(let e){
    print(e)
}
