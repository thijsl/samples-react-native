package com.theoplayerreactnative.events;


import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.theoplayer.android.api.event.EventListener;
import com.theoplayer.android.api.event.EventType;
import com.theoplayer.android.api.event.player.PlayEvent;
import com.theoplayer.android.api.event.player.PlayerEventTypes;

public class PlayEventListener implements EventListener<PlayEvent> {

        public static final EventType<PlayEvent> TYPE = PlayerEventTypes.PLAY;
        private DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter;

        public PlayEventListener(DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter) {
                this.eventEmitter = eventEmitter;
        }

        @Override
        public void handleEvent(PlayEvent playEvent) {
                WritableMap eventGlobal = Arguments.createMap();
                eventEmitter.emit(TYPE.getName(), eventGlobal);
        }
}