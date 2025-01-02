import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import deviceinfo from '@ohos.deviceInfo';
import { Logger } from '../utils/Log';
import { BusinessError } from '@ohos.base';
import systemDateTime from '@ohos.systemDateTime';
// import brightness from '@ohos.brightness';
//import brightness, { BrightnessModeResponse, BrightnessResponse } from '@system.brightness';
import batteryInfo from '@ohos.batteryInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import display from '@ohos.display';
import I18n from '@ohos.i18n';
import sim from '@ohos.telephony.sim';
import connection from '@ohos.net.connection';
import statvfs from '@ohos.file.statvfs';
import fs from '@ohos.file.fs';
import identifier from '@ohos.identifier.oaid';
import FileUtils from '../utils/FileUtils';
import { common } from '@kit.AbilityKit';
import json from '@ohos.util.json';

const TAG = 'DeviceInfoPage'

class DeviceInfoItem {
  index: number
  lable: string
  value: string

  constructor(index: number, lable: string, value: string) {
    this.index = index
    this.lable = lable
    this.value = value
  }
}

@Entry
@Component
struct DeviceInfoPage {
  @State mDataList: Array<DeviceInfoItem> = []

  aboutToAppear() {

  }

  aboutToDisappear() {

  }

  onPageShow() {
    let context: Context = getContext(this) as common.UIAbilityContext;
    let promise = getDeviceInfo(context)
    promise.then((dataList: Array<DeviceInfoItem>) => {
      this.mDataList = dataList
    }).catch((err: BusinessError) => {
      Logger.error(TAG, "err.message")
    })
  }

  onPageHide() {

  }

  build() {
    Row() {
      Navigation() {
        List() {
          ForEach(this.mDataList, (item: DeviceInfoItem) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
                Text(`${item.index}.${item.lable}`).fontSize(16)

                Text(item.value).fontSize(16).margin({
                  left: '40vp',
                })
              }
              .backgroundColor($r('app.color.start_window_background'))
              .width('100%')
              .padding({
                top: 10,
                bottom: 10,
                left: 20
              })
            }
          }, (item: DeviceInfoItem) => item.index.toString())
        }.divider({
          strokeWidth: 1,
          startMargin: 60,
          endMargin: 10,
          color: '#ffe9f0f0',
        })
      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title('设备信息')
      .titleMode(NavigationTitleMode.Mini)
    }
    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }
}

async function getDeviceInfo(context: Context): Promise<Array<DeviceInfoItem>> {
  const result: Array<DeviceInfoItem> = await new Promise(async (resolve: Function) => {
    let listdata = new Array<DeviceInfoItem>()
    let index = 0;
    listdata.push(new DeviceInfoItem(index, "fmVersion", "1.0"))
    listdata.push(new DeviceInfoItem(++index, "os", "harmony"))
    //clientId
    listdata.push(new DeviceInfoItem(++index, "clientId", ""))
    //screenResolution
    let displayInfo = display.getDefaultDisplaySync()

    listdata.push(new DeviceInfoItem(++index, "screenResolution", displayInfo.width + "x" + displayInfo.height + "\n"
      + displayInfo.xDPI + "x" + displayInfo.yDPI))
    //currentTime
    // const currentTime: number = Date.parse(new Date().toString());
    // const currentTime: number = Date.now();
    const currentTime: number = systemDateTime.getTime(false)
    listdata.push(new DeviceInfoItem(++index, "currentTime", currentTime + ""))
    //upTime
    try {
      let upTime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, true);
      listdata.push(new DeviceInfoItem(++index, "upTime", upTime + ""))
    } catch (e) {
      let error = e as BusinessError;
      console.info(`Failed to get uptime. message: ${error.message}, code: ${error.code}`);
    }
    //activeTime
    await systemDateTime.getRealActiveTime(true).then((activeTime: number) => {
      listdata.push(new DeviceInfoItem(++index, "activeTime", activeTime + ""))
    })

    //realTime bootTime
    await systemDateTime.getRealTime(true).then((realTime: number) => {
      listdata.push(new DeviceInfoItem(++index, "realTime", realTime + ""))
    })

    //timeZone
    let timeZone = systemDateTime.getTimezoneSync()
    listdata.push(new DeviceInfoItem(++index, "timeZone", timeZone))

    //language
    try {
      let systemLanguage: string = I18n.System.getSystemLanguage(); // systemLanguage为当前系统语言
      listdata.push(new DeviceInfoItem(++index, "language", systemLanguage))
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`call System.getSystemLanguage failed, error code: ${err.code}, message: ${err.message}.`);
    }

    //brightness todo 去除
    // listdata.push(new DeviceInfoItem(++index, "brightness", ""))


    //batteryStatus
    listdata.push(new DeviceInfoItem(++index, "batteryStatus", batteryInfo.chargingStatus.toString()))
    //batteryLevel
    listdata.push(new DeviceInfoItem(++index, "batteryLevel", batteryInfo.batterySOC + ""))
    //batteryPluggedType
    listdata.push(new DeviceInfoItem(++index, "batteryPluggedType", batteryInfo.pluggedType.toString()))
    //batteryTechnology
    listdata.push(new DeviceInfoItem(++index, "batteryTechnology", batteryInfo.technology))

    //batteryChargeType todo 去除
    // listdata.push(new DeviceInfoItem(++index, "batteryChargeType", ""))

    //设备信息

    let deviceTypeInfo: string = deviceinfo.deviceType;
    listdata.push(new DeviceInfoItem(++index, "deviceType", deviceTypeInfo))
    console.info('the value of the deviceType is :' + deviceTypeInfo);

    let manufactureInfo: string = deviceinfo.manufacture;
    listdata.push(new DeviceInfoItem(++index, "manufacture", manufactureInfo))
    console.info('the value of the manufactureInfo is :' + manufactureInfo);

    let brandInfo: string = deviceinfo.brand;
    listdata.push(new DeviceInfoItem(++index, "brand", brandInfo))
    console.info('the value of the device brand is :' + brandInfo);

    let marketNameInfo: string = deviceinfo.marketName;
    listdata.push(new DeviceInfoItem(++index, "marketNam", marketNameInfo))
    console.info('the value of the deviceinfo marketName is :' + marketNameInfo);

    let productSeriesInfo: string = deviceinfo.productSeries;
    listdata.push(new DeviceInfoItem(++index, "productSeries", productSeriesInfo))
    console.info('the value of the deviceinfo productSeries is :' + productSeriesInfo);

    let productModelInfo: string = deviceinfo.productModel;
    listdata.push(new DeviceInfoItem(++index, "productModel", productModelInfo))
    console.info('the value of the deviceinfo productModel is :' + productModelInfo);

    let softwareModelInfo: string = deviceinfo.softwareModel;
    listdata.push(new DeviceInfoItem(++index, "softwareModel", softwareModelInfo))
    console.info('the value of the deviceinfo softwareModel is :' + softwareModelInfo);

    let hardwareModelInfo: string = deviceinfo.hardwareModel;
    listdata.push(new DeviceInfoItem(++index, "hardwareModel", hardwareModelInfo))
    console.info('the value of the deviceinfo hardwareModel is :' + hardwareModelInfo);

    let hardwareProfileInfo: string = deviceinfo.hardwareProfile;
    listdata.push(new DeviceInfoItem(++index, "hardwareProfile", hardwareProfileInfo))
    console.info('the value of the deviceinfo hardwareProfile is :' + hardwareProfileInfo);

    let serialInfo: string = deviceinfo.serial;
    listdata.push(new DeviceInfoItem(++index, "serial", serialInfo))
    console.info('the value of the deviceinfo serial is :' + serialInfo);

    let bootloaderVersionInfo: string = deviceinfo.bootloaderVersion;
    listdata.push(new DeviceInfoItem(++index, "bootloaderVersion", bootloaderVersionInfo))
    console.info('the value of the deviceinfo bootloaderVersion is :' + bootloaderVersionInfo);

    let abiListInfo: string = deviceinfo.abiList;
    listdata.push(new DeviceInfoItem(++index, "abiList", abiListInfo))
    console.info('the value of the deviceinfo abiList is :' + abiListInfo);

    let securityPatchTagInfo: string = deviceinfo.securityPatchTag;
    listdata.push(new DeviceInfoItem(++index, "securityPatchTag", securityPatchTagInfo))
    console.info('the value of the deviceinfo securityPatchTag is :' + securityPatchTagInfo);

    let displayVersionInfo: string = deviceinfo.displayVersion;
    listdata.push(new DeviceInfoItem(++index, "displayVersion", displayVersionInfo))
    console.info('the value of the deviceinfo displayVersion is :' + displayVersionInfo);

    let incrementalVersionInfo: string = deviceinfo.incrementalVersion;
    listdata.push(new DeviceInfoItem(++index, "incrementalVersion", incrementalVersionInfo))
    console.info('the value of the deviceinfo incrementalVersion is :' + incrementalVersionInfo);

    let osReleaseTypeInfo: string = deviceinfo.osReleaseType;
    listdata.push(new DeviceInfoItem(++index, "mosReleaseType", osReleaseTypeInfo))
    console.info('the value of the deviceinfo osReleaseType is :' + osReleaseTypeInfo);

    let osFullNameInfo: string = deviceinfo.osFullName;
    listdata.push(new DeviceInfoItem(++index, "osFullName", osFullNameInfo))
    console.info('the value of the deviceinfo osFullName is :' + osFullNameInfo);

    let majorVersionInfo: number = deviceinfo.majorVersion;
    listdata.push(new DeviceInfoItem(++index, "majorVersion", majorVersionInfo + ""))
    console.info('the value of the deviceinfo majorVersion is :' + majorVersionInfo);

    let seniorVersionInfo: number = deviceinfo.seniorVersion;
    listdata.push(new DeviceInfoItem(index, "seniorVersion", seniorVersionInfo + ""))
    console.info('the value of the deviceinfo seniorVersion is :' + seniorVersionInfo);

    let featureVersionInfo: number = deviceinfo.featureVersion;
    listdata.push(new DeviceInfoItem(++index, "featureVersion", featureVersionInfo + ""))
    console.info('the value of the deviceinfo featureVersion is :' + featureVersionInfo);

    let buildVersionInfo: number = deviceinfo.buildVersion;
    listdata.push(new DeviceInfoItem(++index, "buildVersion", buildVersionInfo + ""))
    console.info('the value of the deviceinfo buildVersion is :' + buildVersionInfo);

    let sdkApiVersionInfo: number = deviceinfo.sdkApiVersion;
    listdata.push(new DeviceInfoItem(++index, "sdkApiVersion", sdkApiVersionInfo + ""))
    console.info('the value of the deviceinfo sdkApiVersion is :' + sdkApiVersionInfo);

    let firstApiVersionInfo: number = deviceinfo.firstApiVersion;
    listdata.push(new DeviceInfoItem(++index, "firstApiVersion", firstApiVersionInfo + ""))
    console.info('the value of the deviceinfo firstApiVersion is :' + firstApiVersionInfo);

    let versionIdInfo: string = deviceinfo.versionId;
    listdata.push(new DeviceInfoItem(++index, "versionId", versionIdInfo))
    console.info('the value of the deviceinfo versionId is :' + versionIdInfo);

    let buildTypeInfo: string = deviceinfo.buildType;
    listdata.push(new DeviceInfoItem(++index, "buildType", buildTypeInfo))
    console.info('the value of the deviceinfo buildType is :' + buildTypeInfo);

    let buildUserInfo: string = deviceinfo.buildUser;
    listdata.push(new DeviceInfoItem(++index, "buildUser", buildUserInfo))
    console.info('the value of the deviceinfo buildUser is :' + buildUserInfo);

    let buildHostInfo: string = deviceinfo.buildHost;
    listdata.push(new DeviceInfoItem(++index, "buildHost", buildHostInfo))
    console.info('the value of the deviceinfo buildHost is :' + buildHostInfo);

    let buildTimeInfo: string = deviceinfo.buildTime;
    listdata.push(new DeviceInfoItem(++index, "buildTime", buildTimeInfo))
    console.info('the value of the deviceinfo buildTime is :' + buildTimeInfo);

    let buildRootHashInfo: string = deviceinfo.buildRootHash;
    listdata.push(new DeviceInfoItem(++index, "buildRootHash", buildRootHashInfo))
    console.info('the value of the deviceinfo buildRootHash is :' + buildRootHashInfo);

    let udid: string = deviceinfo.udid;
    listdata.push(new DeviceInfoItem(++index, "udid", udid))
    console.info('the value of the deviceinfo udid is :' + udid);

    let odid: string = deviceinfo.ODID;
    listdata.push(new DeviceInfoItem(++index, "odid", odid))
    console.info('the value of the deviceinfo odid is :' + odid);

    let distributionOSName: string = deviceinfo.distributionOSName
    listdata.push(new DeviceInfoItem(++index, "distributionOSName", distributionOSName))
    console.info('the value of the deviceinfo distributionOSName is :' + distributionOSName);

    let distributionOSVersion: string = deviceinfo.distributionOSVersion
    listdata.push(new DeviceInfoItem(++index, "distributionOSVersion", distributionOSVersion))
    console.info('the value of the deviceinfo distributionOSVersion is :' + distributionOSVersion);

    let distributionOSApiVersion: number = deviceinfo.distributionOSApiVersion
    listdata.push(new DeviceInfoItem(++index, "distributionOSApiVersion", distributionOSApiVersion + ""))
    console.info('the value of the deviceinfo distributionOSApiVersion is :' + distributionOSApiVersion);

    let distributionOSReleaseType: string = deviceinfo.distributionOSReleaseType
    listdata.push(new DeviceInfoItem(++index, "distributionOSReleaseType", distributionOSReleaseType))
    console.info('the value of the deviceinfo distributionOSReleaseType is :' + distributionOSReleaseType);

    //customMessage
    listdata.push(new DeviceInfoItem(++index, "customMessage", ""))

    //XXID 既cookieId
    listdata.push(new DeviceInfoItem(++index, "XXID", ""))


    //applicationInfo
    let applicationBundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    let lable = context.resourceManager.getStringSync(applicationBundleInfo.appInfo.labelId)
    console.info(`the value of the deviceinfo applicationBundleInfo lable:${lable}  appInfo is :${json.stringify(applicationBundleInfo.appInfo)}}`);
    listdata.push(new DeviceInfoItem(++index, "applicationInfo", json.stringify(applicationBundleInfo.appInfo)))

    //bundleInfo
    let defaultBundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
    let bundleName = defaultBundleInfo.name
    let bundleVendor = defaultBundleInfo.vendor
    let bundleVersionCode = defaultBundleInfo.versionCode
    let bundleVersionName = defaultBundleInfo.versionName
    let bundleInstallTime = defaultBundleInfo.installTime
    let bundleUptime = defaultBundleInfo.updateTime
    listdata.push(new DeviceInfoItem(++index, "bundleInfo", "bundleName:" + bundleName + "\n"
      + "bundleVendor:" + bundleVendor + "\n"
      + "bundleVersionCode:" + bundleVersionCode + "\n"
      + "bundleVersionName:" + bundleVersionName + "\n"
      + "bundleInstallTime:" + bundleInstallTime + "\n"
      + "bundleUptime:" + bundleUptime + "\n"))

    //bundleSignatureInfo
    let bundleSignatureInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO)
    let signatureInfo = bundleSignatureInfo.signatureInfo
    let appId = signatureInfo.appId
    let appFingerprint = signatureInfo.fingerprint
    listdata.push(new DeviceInfoItem(++index, "bundleSignatureInfo",
      "appId:" + appId + "\n"
        + "appFingerprint:" + appFingerprint + "\n"
    ))

    //simInfo
    let simCountryCode = sim.getISOCountryCodeForSimSync(0)
    // let simCarrier = sim.getSimOperatorNumericSync(0)
    let simCarrier = sim.getSimSpnSync(0)
    let simState = sim.getSimStateSync(0)
    let simCount = sim.getMaxSimCount()
    listdata.push(new DeviceInfoItem(++index, "simInfo" + "\n",
      "simCountryCode:" + simCountryCode + "\n"
        + "simCarrier:" + simCarrier + "\n"
        + "simState:" + simState + "\n"
        + "simCount:" + simCount + "\n"
    ))

    //proxyInfo
    try {
      await connection.getDefaultHttpProxy().then((data: connection.HttpProxy) => {
        listdata.push(new DeviceInfoItem(++index, "proxyInfo", JSON.stringify(data)))
      })
    } catch (err) {
      let error = err as BusinessError
      console.error(`call getDefaultHttpProxy failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "proxyInfo", ""))
    }


    //获取到了netid网络ID，取值为0代表没有默认网络，其余取值必须大于等于100。
    let defaultNetHandle: connection.NetHandle | undefined
    try {
      defaultNetHandle = connection.getDefaultNetSync()
      listdata.push(new DeviceInfoItem(++index, "defaultNetHandle", JSON.stringify(defaultNetHandle)))
    } catch (err) {
      let error = err as BusinessError
      console.error(`call getDefaultNetSync failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "defaultNetHandle", ""))
    }


    //获取defaultNetHandle networkinfo
    try {
      if (defaultNetHandle !== undefined) {
        let connectionProperties = connection.getConnectionPropertiesSync(defaultNetHandle)
        listdata.push(new DeviceInfoItem(++index, "connectionProperties", JSON.stringify(connectionProperties)))
      } else {
        listdata.push(new DeviceInfoItem(++index, "connectionProperties", ""))
      }
    } catch (err) {
      let error = err as BusinessError
      console.error(`call getConnectionPropertiesSync failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "connectionProperties", ""))
    }


    //getAllNets
    let netHandlelist: connection.NetHandle[] | undefined
    try {
      netHandlelist = connection.getAllNetsSync()
      listdata.push(new DeviceInfoItem(++index, "getAllNets", JSON.stringify(netHandlelist)))
    } catch (err) {
      let error = err as BusinessError
      console.error(`call getAllNetsSync failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "getAllNets", ""))
    }


    //netCapabilities
    let netCapabilities: connection.NetCapabilities = {} as connection.NetCapabilities
    try {
      if (defaultNetHandle) {
        netCapabilities = connection.getNetCapabilitiesSync(defaultNetHandle)
        listdata.push(new DeviceInfoItem(++index, "netCapabilities", JSON.stringify(netCapabilities)))
      } else {
        listdata.push(new DeviceInfoItem(++index, "netCapabilities", ""))
      }
    } catch (err) {
      let error = err as BusinessError
      console.error(`call getNetCapabilitiesSync failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "netCapabilities", ""))
    }


    //appNetHandle
    try {
      let appNetHandle = connection.getAppNetSync()
      listdata.push(new DeviceInfoItem(++index, "appNetHandle", JSON.stringify(appNetHandle)))
    } catch (err) {
      let error = err as BusinessError
      console.error(`call getAppNetSync failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "appNetHandle", ""))
    }


    //networkType
    try {
      if (netCapabilities) {
        listdata.push(new DeviceInfoItem(++index, "networkType", netCapabilities.bearerTypes[0] + ""))
      } else {
        listdata.push(new DeviceInfoItem(++index, "networkType", ""))
      }
    } catch (err) {
      let error = err as BusinessError
      console.error(`call networkType failed, error code: ${err.code}, message: ${err.message}.`);
      listdata.push(new DeviceInfoItem(++index, "networkType", ""))
    }


    let path = "/dev";
    //totalStorage
    let totalSize = statvfs.getTotalSizeSync(path)
    listdata.push(new DeviceInfoItem(++index, "totalStorage", totalSize + ""))

    //availableStorage
    let freeSize = statvfs.getFreeSizeSync(path)
    listdata.push(new DeviceInfoItem(++index, "availableStorage", freeSize + ""))


    //networkNames
    let networkNamesLis: Array<string> = []
    try {
      if (netHandlelist !== undefined) {
        netHandlelist.forEach((netHandle: connection.NetHandle) => {
          let connectionProperties = connection.getConnectionPropertiesSync(netHandle)
          networkNamesLis.push(connectionProperties.interfaceName)
        })
      }
    } catch (err) {
      let error = err as BusinessError
      console.error(`call networkNames failed, error code: ${err.code}, message: ${err.message}.`);
    }
    listdata.push(new DeviceInfoItem(++index, "networkNames", networkNamesLis.toString()))


    //cellIp
    if (defaultNetHandle) {
      try {
        let ips: string[] = []
        let connectionProperties = connection.getConnectionPropertiesSync(defaultNetHandle)
        connectionProperties.linkAddresses.forEach((linkAddress: connection.LinkAddress) => {
          let netAddress = linkAddress.address
          if (netAddress.family === 1) {
            ips.push(netAddress.address)
          }
        })
        if (netCapabilities && netCapabilities.bearerTypes[0] === 0) {
          listdata.push(new DeviceInfoItem(++index, "cellIp", ips.toString()))
          listdata.push(new DeviceInfoItem(++index, "wifiIp", ips.toString()))
        } else if (netCapabilities && netCapabilities.bearerTypes[0] === 1) {
          listdata.push(new DeviceInfoItem(++index, "cellIp", ""))
          listdata.push(new DeviceInfoItem(++index, "wifiIp", JSON.stringify(ips.toString())))
        }
      } catch (err) {
        let error = err as BusinessError
        console.error(`call cellIp failed, error code: ${err.code}, message: ${err.message}.`);
      }
    } else {
      listdata.push(new DeviceInfoItem(index, "cellIp", ""))
      listdata.push(new DeviceInfoItem(++index, "wifiIp", ""))
    }


    // //wifiIp
    // try {
    //   let ipInfo = wifiManager.getIpInfo()
    //   listdata.push(new DeviceInfoItem(++index, "wifiIp", JSON.stringify(ipInfo)))
    // } catch (err) {
    //   let error = err as BusinessError
    //   console.error(`call getIpInfo failed, error code: ${err.code}, message: ${err.message}.`);
    //   listdata.push(new DeviceInfoItem(++index, "wifiIp", ""))
    // }


    //vpnIp
    listdata.push(new DeviceInfoItem(++index, "vpnIp", ""))

    fs.readText("/proc/self/maps", (err: BusinessError, str: string) => {
      if (err) {
        console.info("readText failed with error message: " + err.message + ", error code: " + err.code);
      } else {
        console.info("readText succeed:" + str);
      }
    });

    try {
      let oaid = await identifier.getOAID()
      listdata.push(new DeviceInfoItem(++index, "oaid", oaid))
    } catch (err) {

    }
    let bootid_path = "/proc/sys/kernel/random/boot_id"
    let bootid = FileUtils.readFileSync(bootid_path)
    listdata.push(new DeviceInfoItem(++index, "bootid", bootid))

    let maps_path = "/proc/self/maps"

    // FileUtils.readFile(maps_path, { whole: false }).then((result) => {
    //   listdata.push(new DeviceInfoItem(++index, "mapsInfo", result))
    // }).catch((err: BusinessError) => {
    // })
    let mapsInfo = FileUtils.readFileSync(maps_path, { whole: false })
    listdata.push(new DeviceInfoItem(++index, "mapsInfo", mapsInfo))

    let cpuInfo = FileUtils.readFileSync('/proc/cpuinfo')
    listdata.push(new DeviceInfoItem(++index, "cpuInfo", cpuInfo))
    let cpuSpeed = FileUtils.readFileSync('/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq')
    listdata.push(new DeviceInfoItem(++index, "cpuSpeed", cpuSpeed))
    //这个cpuCoreNum读取不到可以通过cpuInfo信息获取
    // let cpuCoreNum = FileUtils.readFileSync('/sys/devices/system/cpu')
    // listdata.push(new DeviceInfoItem(++index, "cpuCoreNum", cpuCoreNum))
    //采集不到
    // let fonts= FileUtils.readFileSync('/system/fonts/')
    // listdata.push(new DeviceInfoItem(++index, "fonts", fonts))
    //   let test= FileUtils.readFileSync('/sys/class/android_usb')
    //   listdata.push(new DeviceInfoItem(++index, "test", test))

    let cloneIndex = context.getApplicationContext().getCurrentAppCloneIndex()
    listdata.push(new DeviceInfoItem(++index, "cloneIndex", cloneIndex + ''))
    resolve(listdata);
  })
  return result
}
