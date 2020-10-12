package com.theoplayerreactnative.events;


import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.theoplayer.android.api.event.EventListener;
import com.theoplayer.android.api.event.EventType;
import com.theoplayer.android.api.event.player.DurationChangeEvent;
import com.theoplayer.android.api.event.player.PlayerEventTypes;

public class DurationEventListener implements EventListener<DurationChangeEvent> {

    public static final EventType<DurationChangeEvent> TYPE = PlayerEventTypes.DURATIONCHANGE;
    private DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter;

    public DurationEventListener(DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter) {
        this.eventEmitter = eventEmitter;
    }

    @Override
    public void handleEvent(DurationChangeEvent durationChangeEvent) {
        WritableMap eventGlobal = Arguments.createMap();
        Double duration = durationChangeEvent.getDuration();
        if (duration != null && (duration.isNaN() || duration.isInfinite())) {
            duration = -1.0;
        }
        eventGlobal.putDouble("duration", duration);
        eventEmitter.emit(TYPE.getName(), eventGlobal);
    }
}