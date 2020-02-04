import React from 'react';
import { Alert, Button, Dimensions, NativeModules, StyleSheet, Text, View, Platform } from 'react-native';
import THEOplayerView from './THEOplayerView'
import THEOeventEmitter from './TheoEventEmitter'

const theoEventEmitter = new THEOeventEmitter();

export default class TheoPlayerViewScreen extends React.Component {
    onPressSetSource = async () => {
        NativeModules.THEOplayerViewManager.setSource(
            {
                sources: [{
                    type: 'application/x-mpegurl',
                    src: 'https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8'
                }],
                poster: 'https://cdn.theoplayer.com/video/big_buck_bunny/poster.jpg'
            }
        );
    }

    onPressSetSourceAd = async () => {
        NativeModules.THEOplayerViewManager.setSource(
            {
                sources: [{
                    type: 'application/x-mpegurl',
                    src: 'https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8'
                }],
                ads: [
                    {
                        sources: "https://cdn.theoplayer.com/demos/preroll.xml",
                        timeOffset: "start",
                        skipOffset: "3"
                    }
                ]
            }
        );
    }

    onPressGetAd = async () => {
        const currentAds = await NativeModules.THEOplayerViewManager.getCurrentAds();
        Alert.alert(currentAds + " ad(s) currently active.")
    }

    onPressSheduleAd = async () => {
        NativeModules.THEOplayerViewManager.scheduleAd({
            sources: "//cdn.theoplayer.com/demos/preroll.xml",
            timeOffset: "start",
        });
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
          //  BaseComponent = ScrollView;
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
                                ads: [
                                    // THEOplayer adv management
                                    {
                                        sources: "https://cdn.theoplayer.com/demos/preroll.xml",
                                        timeOffset: "start",
                                        skipOffset: "3",
                                    },
                                    // Google ima adv management
                                    /*
                                    {
                                        sources: "https://cdn.theoplayer.com/demos/preroll.xml",
                                        integration: "google-ima"
                                    }
                                    */
                                ]
                            }

                        }
                    />

                    <View style={styles.buttonContainer}>
                        <Button
                            style={styles.button}
                            onPress={this.onPressSetSource}
                            title="Set source"
                        />
                    </View>

                    <View style={styles.buttonContainer}>
                        <Button
                            style={styles.button}
                            onPress={this.onPressSetSourceAd}
                            title="Set ad source"
                        />
                    </View>

                    <View style={styles.buttonContainer}>
                        <Button
                            style={styles.button}
                            onPress={this.onPressGetAd}
                            title="Get current ads"
                        />
                    </View>

                    <View style={styles.buttonContainer}>
                        <Button
                            style={styles.button}
                            onPress={this.onPressSheduleAd}
                            title="Schedule an ad"
                        />
                    </View>
                </View>
            </BaseComponent>
        );
    }

    componentWillUnmount() {
        NativeModules.THEOplayerViewManager.destroy();
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
