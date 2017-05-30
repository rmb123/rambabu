import UIKit
import Alamofire
import SVProgressHUD

class AFWrapper: NSObject
{
    class func requestGETURL(strURL: String, params : [String : AnyObject]?,headers : [String : String]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void)
    {
        Alamofire.request(strURL, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
       
            if response.result.isSuccess
            {
                let resJson = response.result.value as! NSDictionary
                success(resJson)
            }
            if response.result.isFailure
            {
                let error : NSError = response.result.error! as NSError
                failure(error)
            }
        }
    }
    
    class func alert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show(withStatus: title);
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        view.view.isUserInteractionEnabled = false;
    }
    
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        view.view.isUserInteractionEnabled = true;
    }


}
