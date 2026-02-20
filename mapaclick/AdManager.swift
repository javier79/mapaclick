//
//  AdManager.swift
//  mapaclick
//
//  Ad management singleton for interstitial ads with frequency control
//

import GoogleMobileAds
import UIKit

class AdManager: NSObject, FullScreenContentDelegate {
    
    // Banner Ad Unit ID - USE TEST ID DURING DEVELOPMENT
    // Real ID: ca-app-pub-5851808404883062/3557275355
    
    //private let bannerAdUnitID = "ca-app-pub-3940256099942544/2435281174" // Google test banner ID
    
    // real Ad Unit ID
    private let bannerAdUnitID = "ca-app-pub-5851808404883062/3557275355"
    
    var lastGameStartShowedAd: Bool = false//tell the game scene whether an interstitial was shown or not.

    private var bannerView: BannerView?
    
    // Singleton instance - use AdManager.shared to access from anywhere
    static let shared = AdManager()
    
    private let firstGameCompletedKey = "firstGameCompleted"
    
    // The loaded interstitial ad ready to be shown
    private var interstitialAd: InterstitialAd?
    
    // Tracks how many times a game has started (for every 2nd game logic)
    private var gameStartCount: Int = 0
    
    // Controls whether ads should be shown (set to false when user pays to remove ads)
    var adsEnabled: Bool = true
    
    // Notification names for pausing/resuming game timer
    static let adWillShowNotification = Notification.Name("AdManagerAdWillShow")
    static let adDismissedNotification = Notification.Name("AdManagerAdDismissed")
    
    // Test Ad Unit ID - USE THIS DURING DEVELOPMENT
    // Replace with your real Ad Unit ID before submitting to App Store:
    // Real ID: ca-app-pub-5851808404883062/4870357028
    
    //private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910" // Google test ID
    
    // real Ad Unit ID
    private let interstitialAdUnitID = "ca-app-pub-5851808404883062/4870357028"
    
    private override init() {
        super.init()
        // Check if user already purchased ad removal
        if StoreManager.isAdRemovalPurchased() {
            adsEnabled = false
        } else {
            loadInterstitialAd()
        }
    }
    
    func checkForExistingPaidUser() {
        let freeVersionKey = "isFreeWithAdsVersion"
        
        // Already purchased through IAP, no need to check
        if StoreManager.isAdRemovalPurchased() { return }
        
        // If this key exists, user installed the free version (not a migrated user)
        if UserDefaults.standard.bool(forKey: freeVersionKey) { return }
        
        // Check if user has any app data (they used the paid version)
        let hasAlphabeticTimes = UserDefaults.standard.integer(forKey: "minutesAlphabetic") != 0 || UserDefaults.standard.integer(forKey: "secondsAlphabetic") != 0
        let hasRandomTimes = UserDefaults.standard.integer(forKey: "minutesRandom") != 0 || UserDefaults.standard.integer(forKey: "secondsRandom") != 0
        
        if hasAlphabeticTimes || hasRandomTimes {
            // Existing paid user — grant ad-free status
            UserDefaults.standard.set(true, forKey: "removeAdsPurchased")
            adsEnabled = false
            print("Existing paid user detected — ads disabled")
        }
        
        // Mark this as the free version for future launches
        UserDefaults.standard.set(true, forKey: freeVersionKey)
    }
    
    func hideBanner() {
        bannerView?.isHidden = true
    }
    
    func removeBanner() {
        bannerView?.removeFromSuperview()
        bannerView = nil
    }
    
    func showBannerAgain() {
        guard let banner = bannerView else { return }
        banner.isHidden = false
    }
    
    /// Call this when a game is completed for the first time
    func markFirstGameCompleted() {
        UserDefaults.standard.set(true, forKey: firstGameCompletedKey)
    }

    /// Check if the user has completed at least one game
    private func hasCompletedFirstGame() -> Bool {
        return UserDefaults.standard.bool(forKey: firstGameCompletedKey)
    }
    
    // MARK: - Banner Ad

    func showBanner(in viewController: UIViewController) {
        guard adsEnabled else { return }
        guard hasCompletedFirstGame() else { return }
        
        // Don't add another banner if one already exists
        if bannerView != nil { return }
        
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = bannerAdUnitID
        banner.rootViewController = viewController
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(banner)
        
        NSLayoutConstraint.activate([
            banner.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor),
            banner.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
        ])
        
        banner.load(Request())
        bannerView = banner
    }
    
    //top banner function
    func showBannerAtTop(in viewController: UIViewController) {
        guard adsEnabled else { return }
        guard hasCompletedFirstGame() else { return }
        
        // Don't add another banner if one already exists
        if bannerView != nil { return }
        
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = bannerAdUnitID
        banner.rootViewController = viewController
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(banner)
        
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            banner.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
        ])
        
        banner.load(Request())
        bannerView = banner
    }


    
    // MARK: - Load Ad
    
    /// Loads a new interstitial ad so it's ready to show when needed
    func loadInterstitialAd() {
        guard adsEnabled else { return }
        
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            print("Interstitial ad loaded successfully")
        }
    }
    
    // MARK: - Show Ad for GameOver (always shows)
    
    /// Shows an interstitial ad when the game is over. Always shows if an ad is loaded.
    func showInterstitialForGameOver() {
        guard adsEnabled else { return }
        guard hasCompletedFirstGame() else { return }
        showAd()
    }
    
    // MARK: - Show Ad for Game Start (every 2nd game, only after tutorial is done)
    
    /// Shows an interstitial ad at game start, but only every 2nd game and only after tutorial has been shown 3 times.
    /*func showInterstitialForGameStart() {
        guard adsEnabled else { return }
        guard hasCompletedFirstGame() else { return }
        // Don't show ads if the tutorial is still active (hasn't been shown 3 times yet)
        if TutorialManager.shouldShowTutorial() {
            return
        }
        
        gameStartCount += 1
        
        // Show ad every 2nd game start
        if gameStartCount % 2 == 0 {
            showAd()
        }
    }*/
    // Shows an interstitial ad at game start, but only every 2nd game and only after tutorial has been shown 3 times. Also tracks whether an interstitial was shown or not.
    func showInterstitialForGameStart() {
        guard adsEnabled else { lastGameStartShowedAd = false; return }
        guard hasCompletedFirstGame() else { lastGameStartShowedAd = false; return }
        
        if TutorialManager.shouldShowTutorial() {
            lastGameStartShowedAd = false
            return
        }
        
        gameStartCount += 1
        
        if gameStartCount % 2 == 0 {
            lastGameStartShowedAd = true
            showAd()
        } else {
            lastGameStartShowedAd = false
        }
    }
    
    /// Check if an ad is ready to show
    func hasAdReady() -> Bool {
        return interstitialAd != nil && adsEnabled && hasCompletedFirstGame()
    }
    
    // MARK: - Private Show Ad Logic
    
    private func showAd() {
        guard let ad = interstitialAd else {
            print("Interstitial ad not ready, loading a new one")
            loadInterstitialAd()
            return
        }
        
        // Get the root view controller to present the ad
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Could not find root view controller to present ad")
            return
        }
        
        ad.present(from: rootViewController)
    }
    
    // MARK: - FullScreenContentDelegate Methods
    
    /// Called when the ad is dismissed by the user
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad dismissed")
        // Notify game scenes to resume timer
        NotificationCenter.default.post(name: AdManager.adDismissedNotification, object: nil)
        // Load the next ad so it's ready for next time
        loadInterstitialAd()
    }
    
    /// Called when the ad fails to present
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial ad failed to present: \(error.localizedDescription)")
        // Load a new ad for next time
        loadInterstitialAd()
    }
    
    /// Called when the ad is about to be presented
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad will present")
        // Notify game scenes to pause timer
        NotificationCenter.default.post(name: AdManager.adWillShowNotification, object: nil)
    }
}
