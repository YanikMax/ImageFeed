import UIKit
import ProgressHUD

//final class UIBlockingProgressHUD {
//    private static var window: UIWindow? {
//        return UIApplication.shared.windows.first
//    }
//
//    internal static var isProgressHUDVisible: Bool = false
//
//    static func show() {
//        DispatchQueue.main.async {
//            window?.isUserInteractionEnabled = false
//            ProgressHUD.show()
//            isProgressHUDVisible = true
//        }
//    }
//
//    static func dismiss() {
//        DispatchQueue.main.async {
//            window?.isUserInteractionEnabled = true
//            ProgressHUD.dismiss()
//            isProgressHUDVisible = false
//        }
//    }
//}


final class UIBlockingProgressHUD {
    
    static var isShowing: Bool = false
    
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }
        return window
    }
    
    internal static var isProgressHUDVisible: Bool = false

    static func show() {
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
