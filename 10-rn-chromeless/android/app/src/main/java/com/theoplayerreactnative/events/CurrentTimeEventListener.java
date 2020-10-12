package com.theoplayerreactnative.events;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.theoplayer.android.api.event.EventListener;
import com.theoplayer.android.api.event.EventType;
import com.theoplayer.android.api.event.player.PlayerEventTypes;
import com.theoplayer.android.api.event.player.TimeUpdateEvent;

public class CurrentTimeEventListener implements EventListener<TimeUpdateEvent> {

    public static final EventType<TimeUpdateEvent> TYPE = PlayerEventTypes.TIMEUPDATE;
    private DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter;

    public CurrentTimeEventListener(DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter) {
        this.eventEmitter = eventEmitter;
    }

    @Override
    public void handleEvent(TimeUpdateEvent timeUpdateEvent) {
        //emit global event
        WritableMap eventGlobal = Arguments.createMap();

        Double timeUpdate = timeUpdateEvent.getCurrentTime();
        if (timeUpdate != null && (timeUpdate.isInfinite() || timeUpdate.isNaN())) {
            timeUpdate = -1.0;
        }
        eventGlobal.putDouble("currentTime", timeUpdate);
        eventEmitter.emit(TYPE.getName(), eventGlobal);

    }
}