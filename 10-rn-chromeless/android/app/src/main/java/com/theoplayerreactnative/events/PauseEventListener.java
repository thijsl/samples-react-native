package com.theoplayerreactnative.events;


import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.theoplayer.android.api.event.EventListener;
import com.theoplayer.android.api.event.EventType;
import com.theoplayer.android.api.event.player.PauseEvent;
import com.theoplayer.android.api.event.player.PlayerEventTypes;

public class PauseEventListener implements EventListener<PauseEvent> {

        public static final EventType<PauseEvent> TYPE = PlayerEventTypes.PAUSE;
        private DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter;

        public PauseEventListener(DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter) {
                this.eventEmitter = eventEmitter;
        }

        @Override
        public void handleEvent(PauseEvent pauseEvent) {
                WritableMap eventGlobal = Arguments.createMap();
                eventEmitter.emit(TYPE.getName(), eventGlobal);
        }
}