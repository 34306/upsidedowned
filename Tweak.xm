#import <UIKit/UIKit.h>

static uint16_t forcePadIdiom = 0;

//just a kopycat from TrollPad (https://github.com/khanhduytran0/TrollPad)
%hook UIDevice
- (UIUserInterfaceIdiom)userInterfaceIdiom {
    if (forcePadIdiom > 0) {
        return UIUserInterfaceIdiomPad;
    } else {
        return %orig;
    }
}
%end

%hook SBTraitsSceneParticipantDelegate
// Allow upside down
- (BOOL)_isAllowedToHavePortraitUpsideDown {
    return YES;
}

- (NSInteger)_orientationMode {
    forcePadIdiom++;
    NSInteger result = %orig;
    forcePadIdiom--;
    return result;
}
%end

%hook SpringBoard
// Allow landscape Home Screen
- (NSInteger)homeScreenRotationStyle {
    return 1;
}
%end

%hook SBApplication
- (BOOL)isMedusaCapable {
    return YES;
}
%end

// Allow upside down Home Screen
%hook SBHomeScreenViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return %orig | UIInterfaceOrientationMaskPortraitUpsideDown;
}
%end

// Allow upside down Lock Screen
%hook SBCoverSheetPrimarySlidingViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return %orig | UIInterfaceOrientationMaskPortraitUpsideDown;
}
%end