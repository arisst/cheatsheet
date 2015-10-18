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