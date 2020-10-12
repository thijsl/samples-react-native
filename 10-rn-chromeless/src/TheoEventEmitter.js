import {NativeEventEmitter, NativeModules} from 'react-native';

//import { DeviceEventEmitter } from 'react-native'; //android
const {ReactNativeEventEmitter} = NativeModules; //ios + android (ReactNativeEventEmitterHelper android only)
const theoEventEmitter = /*Platform.OS === 'ios' ? */new NativeEventEmitter(ReactNativeEventEmitter) /* : DeviceEventEmitter*/;

export default class TheoEventEmitter {

    addListener(eventType, listener) {
        return theoEventEmitter.addListener(eventType, listener);
    }

}