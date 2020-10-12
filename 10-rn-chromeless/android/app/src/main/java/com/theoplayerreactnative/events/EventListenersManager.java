package com.theoplayerreactnative.events;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.theoplayer.android.api.THEOplayerView;
import com.theoplayer.android.api.player.Player;

public class EventListenersManager {

    private final THEOplayerView playerView;
    private final DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter;
    private PlayEventListener playEventListener;
    private PauseEventListener pauseEventListener;
    private DurationEventListener durationEventListener;
    private CurrentTimeEventListener currentTimeEventListener;

    public EventListenersManager(THEOplayerView playerView, DeviceEventManagerModule.RCTDeviceEventEmitter eventEmitter) {
        this.playerView = playerView;
        this.eventEmitter = eventEmitter;
    }

    public void registerListeners() {
        Player player = playerView.getPlayer();
        player.addEventListener(PlayEventListener.TYPE, getPlayEventListener());
        player.addEventListener(PauseEventListener.TYPE, getPauseEventListener());
        player.addEventListener(DurationEventListener.TYPE, getDurationEventListener());
        player.addEventListener(CurrentTimeEventListener.TYPE, getCurrentTimeEventListener());
    }

    public void unregisterListeners() {
        Player player = playerView.getPlayer();
        player.removeEventListener(PlayEventListener.TYPE, getPlayEventListener());
        player.removeEventListener(PauseEventListener.TYPE, getPauseEventListener());
        player.removeEventListener(DurationEventListener.TYPE, getDurationEventListener());
        player.removeEventListener(CurrentTimeEventListener.TYPE, getCurrentTimeEventListener());

    }

    private PlayEventListener getPlayEventListener() {
        if (playEventListener == null) {
            playEventListener = new PlayEventListener(eventEmitter);
        }
        return playEventListener;
    }

    public PauseEventListener getPauseEventListener() {
        if (pauseEventListener == null) {
            pauseEventListener = new PauseEventListener(eventEmitter);
        }
        return pauseEventListener;
    }

    public DurationEventListener getDurationEventListener() {
        if (durationEventListener == null) {
            durationEventListener = new DurationEventListener(eventEmitter);
        }
        return durationEventListener;
    }

    public CurrentTimeEventListener getCurrentTimeEventListener() {
        if (currentTimeEventListener == null) {
            currentTimeEventListener = new CurrentTimeEventListener(eventEmitter);
        }
        return currentTimeEventListener;
    }
}