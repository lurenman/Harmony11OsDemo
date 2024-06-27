import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { Logger } from '../utils/Log';
import { common } from '@kit.AbilityKit';
import settings from '@ohos.settings';
import { promptAction } from '@kit.ArkUI';

const TAG = 'SettingPage'


@Entry
@Component
struct SettingPage {
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
            Button('获取屏幕亮度')
              .bStyle()
              .onClick(() => {
                let value = settings.getValueSync(this.context, settings.display.SCREEN_BRIGHTNESS_STATUS, '0');
                Logger.debug(TAG, `get screen brightness value:${value}`)
                promptAction.showToast({
                  message: `brightness:${value}`
                })
              })

            Button('获取设备名称')
              .bStyle()
              .onClick(() => {
                let value = settings.getValueSync(this.context, settings.general.DEVICE_NAME, "");
                Logger.debug(TAG, `get deviceName value:${value}`)
                promptAction.showToast({
                  message: `deviceName:${value}`
                })
              })
            Button('获取设备启动次数')
              .bStyle()
              .onClick(() => {
                //let value = settings.getValueSync(this.context, settings.general.BOOT_COUNTING, '0');
                settings.getValue(this.context, settings.general.BOOT_COUNTING).then((value) => {
                  Logger.debug(TAG, `get boot_count value:${value}`)
                  promptAction.showToast({
                    message: `boot_count:${value}`
                  })
                });

              })
            Button('获取hdcstate')
              .bStyle()
              .onClick(() => {
                //let value = settings.getValueSync(this.context, settings.general.HDC_STATUS, "");
                settings.getValue(this.context, settings.general.HDC_STATUS).then((value) => {
                  Logger.debug(TAG, `get hdcstate value:${value}`)
                  promptAction.showToast({
                    message: `hdcstate:${value}`
                  })
                });
              })
            Button('获取development')
              .bStyle()
              .onClick(() => {
                //let value = settings.getValueSync(this.context, settings.general.DEVELOPMENT_SETTINGS_STATUS, "");
                settings.getValue(this.context, settings.general.DEVELOPMENT_SETTINGS_STATUS).then((value) => {
                  Logger.debug(TAG, `get development value:${value}`)
                  promptAction.showToast({
                    message: `development:${value}`
                  })
                });
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

