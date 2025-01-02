import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { Logger } from '../utils/Log';
import { common } from '@kit.AbilityKit';
import settings from '@ohos.settings';
import { promptAction, window } from '@kit.ArkUI';

const TAG = 'WindowPage'


@Entry
@Component
struct WindowPage {
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
              .onClick(async () => {
                let mainWindow = this.context.windowStage.getMainWindowSync()
                let lastWindow =await window.getLastWindow(this.context)
                let windowProperties = lastWindow.getWindowProperties()
                let windowBrightness= windowProperties.brightness
                // 屏幕亮度值。该参数为浮点数，取值范围为[0.0, 1.0]或-1.0。1.0表示最亮，-1.0表示默认亮度。
                if (windowBrightness == -1) {
                  let settingsBrightness: string = await settings.getValue(getContext(this), settings.display.SCREEN_BRIGHTNESS_STATUS); // [0, 255]
                  windowBrightness = Number.parseInt(settingsBrightness) / 255 * 100;
                } else {
                  windowBrightness = windowBrightness * 100;
                }
                Logger.debug(TAG, `get screen brightness value:${windowBrightness}`)
                promptAction.showToast({
                  message: `brightness:${windowBrightness}`
                })
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

