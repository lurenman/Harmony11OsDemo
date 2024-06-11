import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import router from '@ohos.router';
import HashMap from '@ohos.util.HashMap';
import { httpGet } from '../utils/HttpUtil';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';

const TAG = 'BlackboxPage'

class DeviceInfoItem {
  key: string;
  value: string;

  constructor(key: string, value: string) {
    this.key = key;
    this.value = value;
  }
}

@Entry
@Component
struct BlackboxPage {
  private mBlackbox: string | undefined
  @State mDataList: Array<DeviceInfoItem> = []
  @State isShowProgress: boolean = true

  aboutToAppear() {
    interface Params {
      blackbox: string
    }

    const params: Params = router.getParams() as Params
    this.mBlackbox = params.blackbox
    if (this.mBlackbox) {
      //查询blackbox
      setTimeout(()=>{
        if (this.mBlackbox) {
          this.onGetRequest(this.mBlackbox)
        }
      },1000)
    //  this.onGetRequest(this.mBlackbox)
    }
  }

  build() {
    Row() {
      Navigation() {
        if (this.isShowProgress) {
          Column({ space: 5 }) {
            LoadingProgress()
              .color(Color.Blue)
              .width(60)
              .height(60)
          }.width('100%').height('100%').justifyContent(FlexAlign.Center).margin({ top: 5 })
        }
        List() {
          ForEach(this.mDataList, (item: DeviceInfoItem) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
                Text(`${item.key}`).fontSize(16)

                Text(item.value + "").fontSize(16).margin({
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
          }, (item: DeviceInfoItem) => item.key.toString())
        }.divider({
          strokeWidth: 1,
          startMargin: 60,
          endMargin: 10,
          color: '#ffe9f0f0',
        })

      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title('查询blackbox')
      .titleMode(NavigationTitleMode.Mini)
    }
    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }

  async onGetRequest(blackbox: string) {
    try {
      let url = "https://fppoc.tcloud.tongdun.cn/restricted/androidQuery.json"
      let params = new HashMap<string, string>()
      params.set('partner_code', "tongdun"); // 此处值填写您的合作方标识
      params.set('event_id', "android_login"); // 此处填写策略集上的事件标识
      params.set('resp_detail_type', "device");
      params.set('black_box', blackbox); //此处填写移动端sdk采集到的信息black_box
      let result = await httpGet(url, params);
      if (result && result.responseCode === http.ResponseCode.OK) {
        let data = result.result
        console.debug(TAG, "onGetRequest httpPost success")
        console.debug(TAG, data)
        let dataJson: object = JSON.parse(data as string)
        if (dataJson['code'] === "000") {
          let resultObj: object = dataJson['result']
          let tempList: Array<DeviceInfoItem> = []
          //注意object的遍历方式
          Object.keys(resultObj).forEach(key => {
            const value = resultObj[key] as string;
            tempList.push(new DeviceInfoItem(key, value))
          });

          if (tempList.length > 0) {
            this.mDataList = tempList
          }
          this.isShowProgress = false
        }
      }
    } catch (error) {
      promptAction.showToast({
        message: $r('app.string.http_response_error')
      })
      this.isShowProgress = false
    }
  }
}
