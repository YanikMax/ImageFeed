import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    internal static var isProgressHUDVisible: Bool = false
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
            isProgressHUDVisible = true
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            isProgressHUDVisible = false
        }
    }
}
