import React from 'react';
import {
  NativeModules,
  Dimensions,
  StyleSheet,
  View,
  Platform,
  ScrollView,
  Text,
  TouchableHighlight,
  TVEventHandler
} from 'react-native';
import {padStart} from 'lodash';
import THEOplayerView from './THEOplayerView';
import THEOeventEmitter from './TheoEventEmitter';
import Orientation from 'react-native-orientation';

const theoEventEmitter = new THEOeventEmitter();

export default class TheoPlayerViewScreen extends React.Component {
  _tvEventHandler: any;

  constructor(props) {
    super(props);
    this.state = {
      paused: true,
      playPauseButtonTitle: 'Play',
      fullscreenTitle: 'Fullscreen on',
      duration: 0,
      currentTime: 0,
    };

    this._listeners = [];
    this._timelineLeftDistance = 0;
    this._timelineWidth = 0;
  }

  componentDidMount() {
    // Add duration and time listeners
    this._listeners['durationchange'] = theoEventEmitter.addListener('durationchange', (event) => {
      this.setState({duration: event.duration});
    })

    this._listeners['timeupdate'] = theoEventEmitter.addListener('timeupdate', (event) => {
      this.setState({currentTime: event.currentTime});
    })

    if (Platform.OS === 'android') {
      this._listeners['fullscreenOff'] = theoEventEmitter.addListener('fullscreenOff', () => {
        this.setState({isFullscreen: false})
      })
      Orientation.lockToPortrait()
    }
    this._enableTVEventHandler(); // Initialize tv event handler
  }

  componentWillUnmount() {
    // Remove all listeners
    Object.keys(this._listeners).forEach(key => {
      this._listeners[key].remove();
    });
    this._disableTVEventHandler(); // Destroy tv event handler
    NativeModules.THEOplayerViewManager.stop();
  }

  _enableTVEventHandler = () => {
    // If platform is not TV then don't implement TV event handler
    if (!Platform.isTV) {
      return;
    }

    this._tvEventHandler = new TVEventHandler();
    this._tvEventHandler.enable(this, (cmp, evt) => {
      if (evt && evt.eventType === 'playPause' && Platform.isTVOS) { // Detect event e.g. playPause from TVOS
        this.togglePlayPause(); // Call method for event
      }
      if (evt && evt.eventType === 'up' || evt.eventType === 'swipeUp' && Platform.isTVOS) { // Detect event e.g. select from TVOS
        this.toggleFullscreen(); // Call method for event
      }
      if (evt && evt.eventType === 'left' || evt.eventType === 'swipeLeft' && Platform.isTVOS) { // Detect event e.g. left from TVOS
        this.onForwardBackwardPress(false); // Call method for event
      }
      if (evt && (evt.eventType === 'right' || evt.eventType === 'swipeRight') && Platform.isTVOS) { // Detect event e.g. right from TVOS
        this.onForwardBackwardPress(); // Call method for event
      }
    });
  }

  _disableTVEventHandler = () => {
    // If platform is not TV then don't implement TV event handler
    if (!Platform.isTV) {
      return;
    }

    if (this._tvEventHandler) {
      this._tvEventHandler.disable(); // Disable handler
      delete this._tvEventHandler; // Remove handler
    }
  }

  formatTime = (time = 0) => {
    // Format time for the readable value
    const {duration} = this.state;
    const _time = Math.min(Math.max(time, 0), duration);
    let formattedMinutes = padStart(Math.floor(_time / 60).toFixed(0), 2, '0')
    let formattedSeconds = padStart(Math.floor(_time % 60).toFixed(0), 2, '0')

    formattedMinutes === '-1' && (formattedMinutes = '00');
    formattedSeconds === '-1' && (formattedSeconds = '00');

    return `${formattedMinutes}:${formattedSeconds}`;
  }

  togglePlayPause = () => {
    const {paused} = this.state;

    if (paused) {
      NativeModules.THEOplayerViewManager.play(); // Use play method declarated in the THEOplayerViewManager(check article React native - ios event listeners)
    } else {
      NativeModules.THEOplayerViewManager.pause(); // Use pause method declarated in the THEOplayerViewManager(check article React native - ios event listeners)
    }
  }

  toggleFullscreen = () => {
    // Only turn on fullscreen, all fullscreen logic is managed by native fullscreen
    NativeModules.THEOplayerViewManager.fullscreenOn();
    if (Platform.OS === 'android') {
      this.setState({isFullscreen: true})
    }
  }

  updatePausedState = (paused) => {
    // Set btn state & label name
    this.setState({
      paused,
      playPauseButtonTitle: paused ? 'Play' : 'Pause'
    });
  }

  getProgressPosition = () => {
    const {currentTime, duration} = this.state;
    return currentTime / duration * 100;
  }

  getPositionFromEvent = (event) => {
    let mX = event.nativeEvent.pageX;
    let position = mX - this._timelineLeftDistance;
    return position;
  }

  onTimelinePress = (event) => {
    const {duration} = this.state;
    const position = this.getPositionFromEvent(event);
    const selectedTime = position / this._timelineWidth * duration;
    NativeModules.THEOplayerViewManager.setCurrentTime(Math.round(selectedTime));
  }

  onForwardBackwardPress = (add = true, time = 15) => {
    const {currentTime} = this.state;
    const selectedTime = add ? currentTime + time : currentTime - time;
    NativeModules.THEOplayerViewManager.setCurrentTime(selectedTime);
  }

  render() {
    const {currentTime, duration, fullscreenTitle, playPauseButtonTitle, isFullscreen} = this.state;
    /*
      Problem on android fullscreen change with theoplayer scaling when ScrollView component is set
    */
    let BaseComponent = View;

    /*
      If there are scaling issues during the change of the fullscreen remove 'aspectRatio' & set player height
    */
    let playerStyle = {
      ...styles.player,
    };

    if (Platform.OS === 'android') {
      // In chromeless mode with custom native fullscreen activity this workaround is not needed
      let width = Math.floor(Dimensions.get('window').width);
      let height = Math.floor(Dimensions.get('window').height);
      if (isFullscreen) {
        playerStyle.width = Math.min(width, height) + 1;
      } else {
        playerStyle.width = Math.min(width, height);
      }
    } else {
      BaseComponent = ScrollView;
    }

    const timelineBarStyle = {
      width: `${this.getProgressPosition()}%`
    }

    return (
      <BaseComponent style={styles.containerBase}>
        <View style={styles.container}>
          <THEOplayerView
            style={playerStyle}
            fullscreenOrientationCoupling={true}
            autoplay={true}
            onPause={(e) => this.updatePausedState(true)}
            onPlay={(e) => this.updatePausedState(false)}
            onEnded={(e) => this.updatePausedState(true)}
            source={
              {
                sources: [{
                  type: 'application/x-mpegurl',
                  src: 'https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8',
                }],
                poster: 'https://cdn.theoplayer.com/video/big_buck_bunny/poster.jpg',
              }
            }
          />
          <View>
            <TouchableHighlight
              style={styles.timelineTouchable}
              onPress={(event) => !Platform.isTV && this.onTimelinePress(event)}
            >
              <View
                style={styles.timelineContainer}
                onLayout={(event) => {
                  const {width} = event.nativeEvent.layout;
                  this._timelineWidth = width;
                }}
              >
                <View style={[styles.timelineBar, timelineBarStyle]}/>
              </View>
            </TouchableHighlight>
          </View>
          <View style={styles.controlsContainer}>
            <View style={styles.buttonsContainer}>
              <TouchableHighlight
                style={styles.button}
                onPress={this.togglePlayPause}
              >
                <Text style={styles.playPause}>
                  {playPauseButtonTitle}
                </Text>
              </TouchableHighlight>
              <TouchableHighlight
                style={styles.button}
                onPress={this.toggleFullscreen}>
                <Text style={styles.fullscreen}>
                  {fullscreenTitle}
                </Text>
              </TouchableHighlight>
            </View>

            <Text
              style={styles.currentTimeDuration}>{this.formatTime(currentTime)} / {this.formatTime(duration)}</Text>
          </View>
        </View>
      </BaseComponent>
    );
  }
}

const styles = StyleSheet.create({
  containerBase: {
    flex: 1,
  },
  container: {
    flex: 1,
    backgroundColor: 'black',
    width: '100%',
    margin: 0,
    padding: 0
  },
  player: {
    backgroundColor: 'black',
    aspectRatio: 2,
    width: '100%'
  },
  controlsContainer: {
    height: 50,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 5
  },
  playPause: {
    width: 40,
    margin: 8,
    color: 'white',
    textAlign: 'center'
  },
  fullscreen: {
    width: 90,
    margin: 8,
    color: 'white',
    textAlign: 'center'
  },
  currentTimeDuration: {
    width: '50%',
    margin: 8,
    marginTop: 12,
    color: 'white',
    textAlign: 'right'
  },
  buttonsContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  button: {
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    borderRadius: 5,
    marginRight: 10
  },
  timelineContainer: {
    width: '100%',
    height: 5,
    backgroundColor: '#DDDDDD',
  },
  timelineBar: {
    backgroundColor: '#333333',
    width: '100%',
    height: '100%'
  },
  timelineTouchable: {
    paddingBottom: 5
  }
});
