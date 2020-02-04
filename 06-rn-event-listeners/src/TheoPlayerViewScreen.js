import React from 'react';
import { Dimensions, StyleSheet, View, NativeModules, Button, Alert, Platform } from 'react-native'; // Import native modules
import THEOplayerView from './THEOplayerView';
import THEOeventEmitter from './TheoEventEmitter';

const theoEventEmitter = new THEOeventEmitter(); // Create instance of theoplayer event emitter object

export default class TheoPlayerViewScreen extends React.Component {
    constructor(props) {
        super(props);

        this.listeners = {}; // Declarate listeners
    }

    componentWillUnmount() {
        // Remove all declarated event listeners
        Object.keys(this.listeners).forEach(key => {
            this.listeners[key].remove();
        });

        // Destroy theoplayer manager
        NativeModules.THEOplayerViewManager.destroy();
    }

    // Add event listener on button press
    onPressAddEventListener = () => {
        if (!this.listeners['play']) {
            this.listeners['play'] = theoEventEmitter.addListener(
                'play',
                (event) => Alert.alert('Play event')
            );
        }
    }

    // Remove event listener on button press
    onPressRemoveEventListener = () => {
        if (this.listeners['play']) {
          this.listeners['play'].remove();
          delete this.listeners['play'];
        }
    }

    render() {
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
            playerStyle.width = Math.floor(Dimensions.get('window').width);
        } else {
         //   BaseComponent = ScrollView;
        }

        return (
            <BaseComponent style={styles.containerBase}>
                <View style={styles.container}>
                    <THEOplayerView
                        style={playerStyle}
                        fullscreenOrientationCoupling={true}
                        autoplay={true}
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

                    <View style={styles.buttonContainer}>
                        <Button style={styles.button}
                            onPress={this.onPressAddEventListener}
                            title="Add PLAY event listener"
                        />
                    </View>

                    <View style={styles.buttonContainer}>
                        <Button style={styles.button}
                            onPress={this.onPressRemoveEventListener}
                            title="Remove PLAY event listener"
                        />
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
    },

    player: {
        aspectRatio: 1.7,
        backgroundColor: 'black',
    },

    buttonContainer: {
        flex: 1,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'space-around',
        marginBottom: 10,
        marginTop: 10,
    },

    button: {
        flex: 1,
    }
});
