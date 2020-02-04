package com.theoplayerreactnative;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.theoplayer.android.api.ads.Ad;
import com.theoplayer.android.api.player.RequestCallback;
import com.theoplayer.android.api.source.SourceDescription;
import com.theoplayer.android.api.source.addescription.THEOplayerAdDescription;

import java.util.List;

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

    @ReactMethod
    public void setSource(ReadableMap source) {
        SourceDescription sourceDescription = SourceHelper.parseSourceFromJS(source);
        if (sourceDescription != null) {
            theoPlayerViewManager.playerView.getPlayer().setSource(sourceDescription);
        }
    }

    @ReactMethod
    public void scheduleAd(ReadableMap ad) {
        THEOplayerAdDescription adDescription = SourceHelper.parseTheoAdFromJS(ad);
        if (adDescription != null) {
            theoPlayerViewManager.playerView.getPlayer().getAds().schedule(adDescription);
        }
    }

    @ReactMethod
    public void getCurrentAds(final Promise promise) {
        theoPlayerViewManager.playerView.getPlayer().getAds().requestCurrentAds(new RequestCallback<List<Ad>>() {
            @Override
            public void handleResult(List<Ad> ads) {
                promise.resolve(ads.size());
            }
        });
    }
}
