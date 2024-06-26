import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { Logger } from '../utils/Log';
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@ohos.base';
import { common } from '@kit.AbilityKit';
import { identifier } from '@kit.AdsKit';
import { PermissionUtil } from '../utils/PermissionUtil';
import { util } from '@kit.ArkTS';
import { asset } from '@kit.AssetStoreKit';
import { AAID } from '@kit.PushKit';
import DrmModel from '../viewmodel/DrmModel';
import { audio } from '@kit.AudioKit';
import { display } from '@kit.ArkUI';
const TAG = 'ServicePage'

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
  let str = textDecoder.decodeWithStream(arr, { stream: false })
  return str;
}

@Entry
@Component
struct ServicePage {
  private context = getContext(this) as common.UIAbilityContext;

  @Styles
  bStyle(){
    .width('100%')
    .height('40vp')
    .backgroundColor($r('app.color.login_button_color'))
    .margin({
      top: '30vp',
      bottom: '10vp'
    })
  }

  build() {
    Row() {
      Navigation() {
        Scroll() {
          Column() {
            Button('获取无障碍服务列表')
              .bStyle()
              .onClick(() => {
                let abilityType: accessibility.AbilityType = 'all';
                let abilityState: accessibility.AbilityState = 'install';
                accessibility.getAccessibilityExtensionList(abilityType, abilityState)
                  .then((data: accessibility.AccessibilityAbilityInfo[]) => {
                    Logger.debug(TAG, `Succeeded in get accessibility extension list, ${JSON.stringify(data)}`)
                    let accessibilityList: Array<object> = []
                    data.forEach((info: accessibility.AccessibilityAbilityInfo) => {
                      const bundleName = info.bundleName
                      const name = info.name
                      const label = info.label
                      let tmplist: Array<string> = []
                      tmplist.push(bundleName)
                      tmplist.push(name)
                      //tmplist.push("华为阅读器")
                      if (label) {
                        tmplist.push(label)
                      } else {
                        tmplist.push('')
                      }
                      accessibilityList.push(tmplist)
                      // let tmplist1: Array<string> = []
                      // tmplist1.push(bundleName)
                      // tmplist1.push(name)
                      // tmplist1.push("la")
                      // accessibilityList.push(tmplist1)
                    })
                    Logger.debug(TAG, `accessibilityList: ${JSON.stringify(accessibilityList)}`)
                  })
                  .catch((err: BusinessError) => {
                    Logger.error(TAG,
                      `failed to get accessibility extension list, Code is ${err.code}, message is ${err.message}`);

                  });
              })
            Button('oaid')
              .bStyle()
              .onClick(() => {
                if (PermissionUtil.checkPermissions('ohos.permission.APP_TRACKING_CONSENT')) {
                  //有权限
                  identifier.getOAID((err: BusinessError, data: string) => {
                    if (err.code) {
                      Logger.error(TAG, `get oaid failed, error: ${err.code} ${err.message}`);
                    } else {
                      const oaid: string = data;
                      Logger.debug(TAG, `succeeded in getting oaid by callback , oaid: ${oaid}`);
                    }
                  })
                } else {
                  //没有权限请求权限
                  let context: Context = getContext(this) as common.UIAbilityContext;
                  PermissionUtil.requestPermissionsFromUser(context, 'ohos.permission.APP_TRACKING_CONSENT')
                    .then((s: boolean) => {
                      if (s) {
                        identifier.getOAID((err: BusinessError, data: string) => {
                          if (err.code) {
                            Logger.error(TAG, `get oaid failed, error: ${err.code} ${err.message}`);
                          } else {
                            const oaid: string = data;
                            Logger.debug(TAG, `succeeded in getting oaid by callback , oaid: ${oaid}`);
                          }
                        })
                      }
                    })
                }
              })

            Button('新增关键资产ArkTS')
              .bStyle()
              .onClick(() => {
                let attr: asset.AssetMap = new Map();
                attr.set(asset.Tag.SECRET,
                  stringToArray('lVW058x+Xh4jdppy+9QsnH5vn4HDDWO7+ev1iprK83xbljfgcLfwCxfPMy4Ie+jyxKgszYePOX/oMHszazUGyA=='));
                attr.set(asset.Tag.ALIAS, stringToArray('td_xxid'));
                //首次解锁后可访问
                attr.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
                //不允许同步关键资产
                attr.set(asset.Tag.SYNC_TYPE, asset.SyncType.THIS_DEVICE);
                //在应用卸载时是否需要保留关键资产。需要权限： ohos.permission.STORE_PERSISTENT_DATA
                attr.set(asset.Tag.IS_PERSISTENT, true);
                //新增关键资产时的冲突（如：别名相同）处理策略。默认就是抛异常
                attr.set(asset.Tag.CONFLICT_RESOLUTION, asset.ConflictResolution.THROW_ERROR);
                //关键资产附属信息，内容由业务自定义且无完整性保护。说明： API12前长度为1-512字节。
                attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('cookieid info'));
                try {
                  asset.add(attr).then(() => {
                    Logger.debug(TAG, `Asset added successfully.`);
                  }).catch((err: BusinessError) => {
                    Logger.error(TAG, `Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
                  })
                } catch (error) {
                  let err = error as BusinessError;
                  Logger.error(TAG, `Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
                }
              })
            Button('查询关键资产ArkTS')
              .bStyle()
              .onClick(() => {
                let query: asset.AssetMap = new Map();
                query.set(asset.Tag.ALIAS, stringToArray('td_xxid')); // 指定了关键资产别名，最多查询到一条满足条件的关键资产
                query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL); // 此处表示需要返回关键资产的所有信息，即属性+明文
                try {
                  asset.query(query).then((res: Array<asset.AssetMap>) => {
                    for (let i = 0; i < res.length; i++) {
                      // parse the secret.
                      let secret: Uint8Array = res[i].get(asset.Tag.SECRET) as Uint8Array;
                      // parse uint8array to string
                      let xxid: string = arrayToString(secret);
                      Logger.debug(TAG, `query td_xxid:${xxid}`);
                    }
                  }).catch((err: BusinessError) => {
                    Logger.error(TAG, `Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
                  });
                } catch (error) {
                  let err = error as BusinessError;
                  Logger.error(TAG, `Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
                }
              })

            Button('更新关键资产ArkTS')
              .bStyle()
              .onClick(() => {
                let query: asset.AssetMap = new Map();
                query.set(asset.Tag.ALIAS, stringToArray('td_xxid'));
                let attrsToUpdate: asset.AssetMap = new Map();
                attrsToUpdate.set(asset.Tag.SECRET, stringToArray('123456789'));
                attrsToUpdate.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('cookieid info update'));
                try {
                  asset.update(query, attrsToUpdate).then(() => {
                    Logger.debug(TAG, `Asset updated successfully.`);
                  }).catch((err: BusinessError) => {
                    Logger.error(TAG, `Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
                  });
                } catch (error) {
                  let err = error as BusinessError;
                  Logger.error(TAG, `Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
                }
              })

            Button('更新关键资产ArkTS')
              .bStyle()
              .onClick(() => {
                let query: asset.AssetMap = new Map();
                query.set(asset.Tag.ALIAS, stringToArray('td_xxid'));
                let attrsToUpdate: asset.AssetMap = new Map();
                attrsToUpdate.set(asset.Tag.SECRET, stringToArray('123456789'));
                attrsToUpdate.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('cookieid info update'));
                try {
                  asset.update(query, attrsToUpdate).then(() => {
                    Logger.debug(TAG, `Asset updated successfully.`);
                  }).catch((err: BusinessError) => {
                    Logger.error(TAG, `Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
                  });
                } catch (error) {
                  let err = error as BusinessError;
                  Logger.error(TAG, `Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
                }
              })

            Button('获取AAID')
              .bStyle()
              .onClick(async () => {
                // 获取AAID
                try {
                  const aaid: string = await AAID.getAAID();
                  //示例:f3de3a7d-613a-4fb5-bc81-7b0f352e4107
                  Logger.debug(TAG, `Succeeded in getting AAID:${aaid}`);
                } catch (err) {
                  let e: BusinessError = err as BusinessError;
                  Logger.error(TAG, `Failed to get AAID. Code is ${err.code}, message is ${err.message}`);
                }
              })

            Button('删除AAID')
              .bStyle()
              .onClick(async () => {
                try {
                  await AAID.deleteAAID()
                  Logger.debug(TAG, `Succeeded delete AAID.`);
                } catch (err) {
                  let e: BusinessError = err as BusinessError;
                  Logger.error(TAG, `Failed to delete AAID. Code is ${err.code}, message is ${err.message}`);
                }
              })
            Button('DRM')
              .bStyle()
              .onClick(() => {
                let isSupported = DrmModel.isMediaKeySystemSupported1("com.wiseplay.drm")
                Logger.debug(TAG, `isSupported:${isSupported}`);
                let uuid = DrmModel.getMediaKeySystemUuid("com.wiseplay.drm")
                Logger.debug(TAG, `drm uuid:${uuid}`);
                let mediaKeySystemDescriptionList = DrmModel.getMediaKeySystems()
                Logger.debug(TAG, `mediaKeySystemDescriptionList:${mediaKeySystemDescriptionList.toString()}`);
              })

            Button('AudioScene')
              .bStyle()
              .onClick(() => {
                let audioManager = audio.getAudioManager();
                audioManager.getAudioScene().then((value: audio.AudioScene) => {
                  Logger.debug(TAG, `Promise returned to indicate that the audio scene mode is obtained ${value}.`);
                }).catch((err: BusinessError) => {
                  Logger.error(TAG, `Failed to obtain the audio scene mode ${err}`);
                });

              })

            Button('检测截屏/投屏/录屏')
              .bStyle()
              .onClick(() => {
                try {
                  let ret: boolean = false;
                  ret = display.isCaptured();
                  Logger.debug(TAG, 'display.isCaptured: ' + ret);
                  /*        let displayClass: Array<display.Display> = [];
                          let promise: Promise<Array<display.Display>> = display.getAllDisplays();
                          promise.then((data: Array<display.Display>) => {
                            displayClass = data;
                            Logger.debug(TAG, 'Succeeded in obtaining all the display objects. Data: ' + JSON.stringify(data));
                          }).catch((err: BusinessError) => {
                            Logger.error(TAG,
                              'Failed to obtain all the display objects. Code: ${err.code}, message: ${err.message}');
                          });*/
                } catch (err) {
                  let error = err as BusinessError
                  Logger.error(TAG, `call 检测录制状态 failed, error code: ${err.code}, message: ${err.message}.`);
                }

              })
          }
          .padding({ left: '20vp', right: '20vp' })
          .width(LAYOUT_WIDTH_OR_HEIGHT)
          .height(LAYOUT_WIDTH_OR_HEIGHT)
          .alignItems(HorizontalAlign.Center)
          .margin({ bottom: '200vp' })
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width(LAYOUT_WIDTH_OR_HEIGHT)
        .height(LAYOUT_WIDTH_OR_HEIGHT)
      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title(TAG)
      .titleMode(NavigationTitleMode.Mini)
    }

    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }
}

