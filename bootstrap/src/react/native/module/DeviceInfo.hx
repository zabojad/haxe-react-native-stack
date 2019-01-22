package react.native.module;

@:jsRequire('react-native-device-info','default')
extern class DeviceInfo {
    static public function getUniqueID() : String;
    static public function getDeviceLocale() : String;
}
