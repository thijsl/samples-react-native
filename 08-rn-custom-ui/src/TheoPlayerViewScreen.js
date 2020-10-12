import React from 'react';
import { Dimensions, NativeModules, StyleSheet, View, Platform, ScrollView } from 'react-native';
import THEOplayerView from './THEOplayerView'

export default class TheoPlayerViewScreen extends React.Component {
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
            BaseComponent = ScrollView;
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
        backgroundColor: "black",
        aspectRatio: 1.7,
    },
});
