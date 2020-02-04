package com.theoplayerreactnative;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class TheoPlayerViewModule extends ReactContextBaseJavaModule {
    private static final String RCT_MODULE_NAME = "THEOplayerViewManager";
    private TheoPlayerViewManager theoPlayerViewManager;

    TheoPlayerViewModule(ReactApplicationContext reactContext, TheoPlayerViewManager theoPlayerViewManager) {
        super(reactContext);
        this.theoPlayerViewManager = theoPlayerViewManager;
    }

    @Override
    public String getName() {
        return RCT_MODULE_NAME;
    }

    @ReactMethod
    public void destroy() {
        theoPlayerViewManager.playerView.onDestroy();
    }
}
