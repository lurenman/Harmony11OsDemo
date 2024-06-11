import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { httpGet, httpPostBuffer } from '../utils/HttpUtil';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import HashMap from '@ohos.util.HashMap';

const TAG = 'NetworkPage'


@Entry
@Component
struct NetworkPage {
  @Styles
  ButtonStyle(){
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
            Button('httpGet')
              .ButtonStyle()
              .onClick(() => {
                this.onGetRequest()
              })
            Button('httpPost')
              .ButtonStyle()
              .onClick(() => {
                //todo
                this.onPostRequest()
              })
            Button('httpPostBuffer')
              .ButtonStyle()
              .onClick(() => {
                //todo
                //this.onPostBufferRequest()

              })
          }
          .padding({ left: '20vp', right: '20vp' })
          .width(LAYOUT_WIDTH_OR_HEIGHT)
          .height(LAYOUT_WIDTH_OR_HEIGHT)
          .alignItems(HorizontalAlign.Center)
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width(LAYOUT_WIDTH_OR_HEIGHT)
        .height(LAYOUT_WIDTH_OR_HEIGHT)
      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title('Network')
      .titleMode(NavigationTitleMode.Mini)
    }

    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }

  async onGetRequest() {
    try {
      let result = await httpGet('https://www.harmonyos.com');
      if (result && result.responseCode === http.ResponseCode.OK) {
        console.debug(TAG, "httpGet success")
        console.debug(TAG, result.result)
      }
    } catch (error) {
      promptAction.showToast({
        message: $r('app.string.http_response_error')
      })
    }
  }

  async onGetRequest1() {
    try {
      let url = "https://nevermore-poc-t.tongdun.net/nevermore-vpc/fp/raw/query.json"
      let blackbox = "lGPVr17033245738CYG8uW9Em5"
      let params = new HashMap<string, string>()
      params.set('blackbox', blackbox)
      let result = await httpGet(url, params);
      if (result && result.responseCode === http.ResponseCode.OK) {
        console.debug(TAG, "onGetRequest1 httpGet success")
        console.debug(TAG, result.result)
      }
    } catch (error) {
      promptAction.showToast({
        message: $r('app.string.http_response_error')
      })
    }
  }

  async onPostRequest() {
    try {
      let url = "https://fppoc.tcloud.tongdun.cn/restricted/androidQuery.json"
      let blackbox = "rGPVU1703562822uVrFJrg8eYf"
      let params = new HashMap<string, string>()
      params.set('partner_code', "tongdun"); // 此处值填写您的合作方标识
      params.set('event_id', "android_login"); // 此处填写策略集上的事件标识
      params.set('resp_detail_type', "device");
      params.set('black_box', blackbox); //此处填写移动端sdk采集到的信息black_box
      let result = await httpGet(url, params);
      if (result && result.responseCode === http.ResponseCode.OK) {
        console.debug(TAG, "onPostRequest httpPost success")
        console.debug(TAG, result.result)
      }
    } catch (error) {
      promptAction.showToast({
        message: $r('app.string.http_response_error')
      })
    }
  }

  async onPostBufferRequest() {
    try {
      let url = "https://sg-fp.apitd.net/android/v1"
      let blackbox = "mGPVk1703328448LSHgh60Ddhd"
      let params = new HashMap<string, string>()
      params.set("partner", 'tongdun');
      params.set("version", '4.1.5.14');
      params.set("appName", 'nihao123');
      // params.set("appKey", '58e1016aaef646670d1ff5a657f501ce');
      let arrayBuffer = new ArrayBuffer(2);
      let result = await httpPostBuffer(url, arrayBuffer, params);
      if (result && result.responseCode === http.ResponseCode.OK) {
        console.debug(TAG, "onPostRequest httpPost success")
        console.debug(TAG, result.result)
      }
    } catch (error) {
      promptAction.showToast({
        message: $r('app.string.http_response_error')
      })
    }
  }
}

