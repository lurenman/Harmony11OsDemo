import http from '@ohos.net.http';
import HashMap from '@ohos.util.HashMap';

/**
 * The request success code.
 */
const SUCCESS_CODE: number = 200;

/**
 * Read timeout.
 */
const READ_TIMEOUT: number = 15000;

/**
 * Connect timeout.
 */
const CONNECT_TIMEOUT: number = 15000;

/**
 *https get 请求
 * @param url
 * @param params
 * @returns
 */
export async function httpGet(url: string, params?: HashMap<string, string>) {
  if (!url) {
    return undefined;
  }
  if (params && !params.isEmpty()) {
    url = url + "?"
    let tempStr = ""
    params.forEach((value, key) => {
      tempStr = tempStr + key + "=" + value + "&"
    })
    url = url + tempStr.substring(0, tempStr.length - 1)
  }
  let request = http.createHttp();
  let options = {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json'
    },
    readTimeout: READ_TIMEOUT,
    connectTimeout: CONNECT_TIMEOUT
  } as http.HttpRequestOptions;
  let result = await request.request(url, options);
  return result;
}


/**
 * http post 请求
 * todo
 * @param url
 * @param params
 * @returns
 */
export async function httpPost(url: string, params?: HashMap<string, string>) {
  if (!url) {
    return undefined;
  }
  let request = http.createHttp()
  let options = {
    method: http.RequestMethod.POST,
    header: ['Content-Type', 'application/x-www-form-urlencoded'],
    extraData: {},
    readTimeout: READ_TIMEOUT,
    connectTimeout: CONNECT_TIMEOUT
  } as http.HttpRequestOptions
  let result = await request.request(url, options);
  return result
}

export async function httpPostBuffer(url: string, bufferArray: ArrayBuffer, params?: HashMap<string, string>) {
  if (!url) {
    return undefined;
  }
  if (params && !params.isEmpty()) {
    url = url + "?"
    let tempStr = ""
    params.forEach((value, key) => {
      tempStr = tempStr + key + "=" + value + "&"
    })
    url = url + tempStr.substring(0, tempStr.length - 1)
  }

  // new Int8Array(bufferArray).forEach((value, index, array) => {
  //   console.log("Native_Test", "Int8Array:" + "index:" + index +"  "+ value.toString())
  // })
  let request = http.createHttp();
  let options = {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/octet-stream'
    },
    extraData: bufferArray,
    readTimeout: READ_TIMEOUT,
    connectTimeout: CONNECT_TIMEOUT
  } as http.HttpRequestOptions;
  let result = await request.request(url, options);
  return result;
}
