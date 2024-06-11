// Worker.ts代码
import worker, { ThreadWorkerGlobalScope, MessageEvents } from '@ohos.worker';
import Handle from '../Handle'; // 返回句柄

let workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 无法传输的句柄，所有操作依赖此句柄
let handler: Handle = new Handle()

// Worker线程的onmessage逻辑
workerPort.onmessage = (e: MessageEvents): void => {
  switch (e.data.type as number) {
    case 0:
      handler.syncSet(e.data.data);
      workerPort.postMessage('success set');
      break
    case 1:
      handler.syncGet();
      workerPort.postMessage('success get');
      break
  }
}