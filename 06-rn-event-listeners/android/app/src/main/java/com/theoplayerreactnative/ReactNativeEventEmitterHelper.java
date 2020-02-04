package com.theoplayerreactnative;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.theoplayer.android.api.event.EventListener;
import com.theoplayer.android.api.event.player.DurationChangeEvent;
import com.theoplayer.android.api.event.player.PlayEvent;
import com.theoplayer.android.api.event.player.PlayerEventTypes;
import com.theoplayer.android.api.event.player.TimeUpdateEvent;

import java.util.Collections;
import java.util.HashMap;
import java.util.Set;
import java.util.TreeSet;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

/**
 * Helper class to handle the dynamic event registration.
 * On iOS it can happen on the emitter itself
 */
public class ReactNativeEventEmitterHelper extends ReactContextBaseJavaModule {

    //static
    public static final String RCT_MODULE_NAME = "ReactNativeEventEmitterHelper";
    private static final String TAG = ReactNativeEventEmitter.class.getSimpleName();

    private class Events {
        static final String PLAY = "play";
    }

    private TheoPlayerViewManager theoPlayerViewManager;

    // Event listener scheduling
    private Set<String> lateInitEventListeners = Collections.synchronizedSet(new TreeSet<String>());
    private final ScheduledExecutorService eventListenerScheduler = Executors.newScheduledThreadPool(1);
    private ScheduledFuture scheduledFutureTaskForEventRegistration;

    protected HashMap<String, EventListener> listeners = new HashMap<String, EventListener>();

    public ReactNativeEventEmitterHelper(ReactApplicationContext reactContext, TheoPlayerViewManager theoPlayerViewManager) {
        super(reactContext);
        this.theoPlayerViewManager = theoPlayerViewManager;
    }

    @Override
    public String getName() {
        return RCT_MODULE_NAME;
    }

    @ReactMethod
    public void registerListenerForEvent(final String event) {
        if (listeners.containsKey(event)) {
            return;
        }

        if (theoPlayerViewManager.playerView == null) {
            // If the view is null, the player is not yet ready, so store the event and reschedule the event listener registration
            lateInitEventListeners.add(event);
            scheduledFutureTaskForEventRegistration = eventListenerScheduler.schedule(new Runnable() {
                @Override
                public void run() {
                    registerListenerForEvent(event);
                }
            }, 1000, TimeUnit.MILLISECONDS);
            return;
        }

        // Else cancel the rescheduling
        if (scheduledFutureTaskForEventRegistration != null) {
            scheduledFutureTaskForEventRegistration.cancel(false);
            scheduledFutureTaskForEventRegistration = null;
        }

        // Maybe a registration event came earlier then the reschedule timer, so make sure this also will be initialised
        if (!lateInitEventListeners.contains(event)) {
            lateInitEventListeners.add(event);
        }
        // And init the stored event listeners
        if (!lateInitEventListeners.isEmpty()) {
            for (String eventName : lateInitEventListeners) {
                initEventListener(eventName);
            }
            lateInitEventListeners.clear();
        }
    }

    private void initEventListener(String event) {
        switch (event) {
            case Events.PLAY :

                final EventListener playListener = new EventListener<PlayEvent>() {
                    @Override
                    public void handleEvent(final PlayEvent playEvent) {
                        // Emit global event
                        WritableMap eventGlobal = Arguments.createMap(); //new map, because the other one get consumed!
                        sendEvent(getReactApplicationContext(), Events.PLAY, eventGlobal);
                    }
                };
                listeners.put(Events.PLAY, playListener);
                theoPlayerViewManager.playerView.getPlayer().addEventListener(PlayerEventTypes.PLAY, playListener);

                break;
            default:
                break;
        }
    }


    // Emit
    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @javax.annotation.Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }


}
