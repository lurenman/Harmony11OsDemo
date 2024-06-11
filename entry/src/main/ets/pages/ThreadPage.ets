import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { Logger } from '../utils/Log';
import taskpool from '@ohos.taskpool';
import worker from '@ohos.worker';

const TAG = 'ThreadPage'

// 跨线程并发任务
@Concurrent
async function produce(): Promise<number> {
  // 添加生产相关逻辑
  // Logger.debug(TAG, "producing...")
  return 3
}

//必须加@Concurrent
function produce1(): number {
  setTimeout(() => {

  }, 3000)
  return 1
}

//@Concurrent 修饰只能使用函数内本地的变量
@Concurrent
function produce2(): number {
  let a = 1
  a++
  return a
}

@Concurrent
function produce3(a: number): number {
  return ++a
}

@Concurrent
async function produce4(a: number): Promise<number> {
  const result: string = await new Promise((resolve: Function) => {
    setTimeout(() => {
      console.debug("produce :" + ++a);
      resolve()
    }, 1000);
  });
  return 4
}

//这种传对象是不可以的
// @Concurrent
// async function produce5(data: dataClass): Promise<dataClass> {
//   const result: dataClass = await new Promise((resolve: Function) => {
//     setTimeout(() => {
//       data.value = "data hello produce fix"
//       resolve(data)
//     }, 1000);
//   });
//   return result
// }

class Consumer {
  public consume(value: number) {
    // 添加消费相关逻辑
    Logger.debug(TAG, "consuming value: " + value)
  }
}

let buffer: ArrayBuffer = new ArrayBuffer(8);
let view: Uint8Array = new Uint8Array(buffer);
let buffer1: ArrayBuffer = new ArrayBuffer(16);
let view1: Uint8Array = new Uint8Array(buffer1);

let sharedBuffer: SharedArrayBuffer = new SharedArrayBuffer(1024);
let shareview: Uint8Array = new Uint8Array(sharedBuffer);

@Concurrent
function testTransfer(arg1: ArrayBuffer, arg2: ArrayBuffer): number {
  console.debug("testTransfer arg1 byteLength: " + arg1.byteLength);
  console.debug("testTransfer arg2 byteLength: " + arg2.byteLength);
  return 100;
}

// @Concurrent
// function testTransferShare(arg1: SharedArrayBuffer): number {
//   console.debug("testTransferShare arg1 byteLength: " + arg1.byteLength);
//   return 100;
// }

@Entry
@Component
struct ThreadPage {
  private a = 1
  static b = 1

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

            Button('Promise')
              .ButtonStyle()
              .onClick(() => {
                // let promise = promiseAsyncFunction(ThreadPage.b)
                // promise.then((result) => {
                //   Logger.debug(TAG, "promise then result:" + result)
                //   Logger.debug(TAG, "promise then b:" + ThreadPage.b)
                // }).catch((err: BusinessError) => {
                //   Logger.debug(TAG, "err.message")
                // })
                // Logger.debug(TAG, "promise on click b:" + ThreadPage.b)
                let data = fetchDataSync()
                Logger.debug(TAG, "promise on click data:" + data)
              })

            Button('Promise1')
              .ButtonStyle()
              .onClick(async () => {
                let data = new dataClass()
                // let promise = promiseAsyncFunction1(data)
                // promise.then((result) => {
                //   Logger.debug(TAG, "promise then result data.value:" + data.value)
                //   Logger.debug(TAG, "promise then data.value:" + data.value)
                // }).catch((err: BusinessError) => {
                //   Logger.debug(TAG, "err.message")
                // })
                // Logger.debug(TAG, "promise on click data.value:" + data.value)
                let result = await promiseAsyncFunction2()
                Logger.debug(TAG, "promiseAsyncFunction2 on click result:" + result)
              })

            Button('taskpool')
              .ButtonStyle()
              .onClick(() => {
                let produceTask: taskpool.Task = new taskpool.Task(produce3, this.a)
                let consumer: Consumer = new Consumer()
                for (let index: number = 0; index < 10; index++) {
                  // 执行生产异步并发任务
                  taskpool.execute(produceTask).then((res: Object) => {
                    if (typeof res === 'number') {
                      consumer.consume(res)
                      Logger.debug(TAG, "produce the res:" + res)
                    }
                  }).catch((e: Error) => {
                    Logger.error(TAG, e.message)
                  })
                }
                Logger.debug(TAG, "produce the a:" + this.a)
              })

            Button('taskpool1')
              .ButtonStyle()
              .onClick(async () => {
                let produceTask: taskpool.Task = new taskpool.Task(produce4, this.a)
                let consumer: Consumer = new Consumer()
                for (let index: number = 0; index < 10; index++) {
                  // 执行生产异步并发任务
                  await taskpool.execute(produceTask).then((res: Object) => {
                    if (typeof res === 'number') {
                      consumer.consume(res)
                      Logger.debug(TAG, "produce the res:" + res)
                    }
                  }).catch((e: Error) => {
                    Logger.error(TAG, e.message)
                  })
                }
                Logger.debug(TAG, "produce the a:" + this.a)
              })

            Button('taskpoolTransfer')
              .ButtonStyle()
              .onClick(() => {
                let task: taskpool.Task = new taskpool.Task(testTransfer, view, view1);
                task.setTransferList([view.buffer, view1.buffer]);
                taskpool.execute(task).then((res: Object) => {
                  Logger.debug(TAG, "testTransfer test result: " + res)
                }).catch((e: string) => {
                  Logger.error(TAG, "testTransfer test catch: " + e)
                })
                Logger.debug(TAG, "testTransfer view byteLength: " + view.byteLength);
                Logger.debug(TAG, "testTransfer view1 byteLength: " + view1.byteLength);
              })
            // Button('taskpoolTransferShare')
            //   .ButtonStyle()
            //   .onClick(() => {
            //     let task: taskpool.Task = new taskpool.Task(testTransferShare, shareview);
            //     task.setTransferList([shareview.buffer]);
            //     taskpool.execute(task).then((res: number) => {
            //       Logger.debug(TAG, "testTransferShare test result: " + res)
            //     }).catch((e: string) => {
            //       Logger.error(TAG, "testTransferShare test catch: " + e)
            //     })
            //     Logger.debug(TAG, "testTransferShare view byteLength: " + shareview.byteLength);
            //   })
            Button('worker')
              .ButtonStyle()
              .onClick(() => {
                let w: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/MyWorker.ts');
                w.onmessage = (res): void => {
                  // 接收Worker子线程的结果
                  Logger.debug(TAG, "worker onmessage:" + res.data);
                }
                w.onerror = (): void => {
                  // 接收Worker子线程的错误信息
                  Logger.debug(TAG, "worker error");
                }
                // 向Worker子线程发送Set消息
                w.postMessage({ 'type': 0, 'data': 'data' })
                // 向Worker子线程发送Get消息
                w.postMessage({ 'type': 1 })
                // ...
                // 根据实际业务，选择时机以销毁线程
                //w.terminate()
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
        .onTouch((event) => {
        })
      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title('Thread')
      .titleMode(NavigationTitleMode.Mini)
    }
    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }
}

class dataClass {
  public value: string = "data hello"
}

/**
 * Promise 测试
 * @returns
 */
async function promiseAsyncFunction(b: number): Promise<number> {
  const result: number = await new Promise((resolve: Function) => {
    setTimeout(() => {
      ThreadPage.b = 4
      resolve(++b);
      //resolve(ThreadPage.b);
    }, 1000);
  });
  return result
}

async function promiseAsyncFunction1(b: dataClass): Promise<dataClass> {
  const result: dataClass = await new Promise((resolve: Function) => {
    setTimeout(() => {
      b.value = "data hello fix"
      resolve(b)
    }, 1000);
  });
  return result
}

async function fetchData(): Promise<string> {
  return "Data fetched";
}

async function fetchDataSync(): Promise<string> {
  const data = await fetchData();
  return data;
}

async function promiseAsyncFunction2(): Promise<string> {
  // const result: string = await new Promise((resolve: Function) => {
  //   return '456'
  // });
  // return result
  return await new Promise((resolve: Function) => {
    resolve('123')

  })
}