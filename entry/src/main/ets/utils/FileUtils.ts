import fs, { ListFileOptions } from '@ohos.file.fs';
import buffer from '@ohos.buffer';
import { BusinessError } from '@ohos.base';

export class FileUtils {
  /**
   * 异步读取文件
   * @param filePath
   * @param fOption
   * @returns
   */
  public async readFile(filePath: string, fOption?: {
    whole: boolean;
    bufSize?: number;
  }): Promise<string> {
    return await new Promise((resolve: Function) => {
      resolve(this.readFileSync(filePath, fOption))
    });
  }

  /**
   * 读取文件
   * @param filePath
   * @param fption
   * @returns
   */
  public readFileSync(filePath: string, fOption?: {
    whole: boolean;
    bufSize?: number;
  }): string {
    let result = ""
    if (!filePath) {
      return result
    }
    try {
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY)
      let readSize = 0;
      let bufSize = 1024;
      if (fOption && fOption.bufSize) {
        bufSize = fOption.bufSize
      }
      let arrayBuffer = new ArrayBuffer(bufSize);
      let option = {
        offset: 0,
        length: bufSize
      }
      option.offset = readSize;
      if (fOption && !fOption.whole) {
        let readLen = fs.readSync(file.fd, arrayBuffer, option)
        let buf = buffer.from(arrayBuffer, 0, readLen)
        result = buf.toString()
      } else {
        let readLen = fs.readSync(file.fd, arrayBuffer, option)
        while (readLen > 0) {
          readSize += readLen
          let buf = buffer.from(arrayBuffer, 0, readLen)
          result = result + buf.toString()
          option.offset = readSize
          readLen = fs.readSync(file.fd, arrayBuffer, option)
        }
      }
      // 关闭文件
      fs.closeSync(file)
    } catch (err) {
      let error = err as BusinessError
      console.error(`call readFileSync failed, error code: ${err.code}, message: ${err.message}.`);
    }
    return result
  }

  /**
   * 异步写文件
   * @param filePath
   * @param content
   * @returns
   */
  public async writeFile(filePath: string, content: string, options?: {
    offset?: number;
    length?: number;
    encoding?: string;
  }): Promise<boolean> {
    return await new Promise((resolve: Function) => {
      resolve(this.writeFileSync(filePath, content, options))
    });
  }

  /**
   * 同步写文件
   * @param filePath
   * @param content
   * @returns
   */
  public writeFileSync(filePath: string, content: string, options?: {
    offset?: number;
    length?: number;
    encoding?: string;
  }): boolean {
    let result = false
    if (!filePath || !content) {
      return result
    }
    try {
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      // 写入一段内容至文件
      fs.writeSync(file.fd, content, options);
      // 关闭文件
      fs.closeSync(file);
      result = true
    } catch (err) {
      let error = err as BusinessError
      console.error(`call writeFileSync failed, error code: ${err.code}, message: ${err.message}.`);
    }
    return result
  }

  /**
   *  异步追加的形式写文件
   * @param filePath
   * @param content
   * @param options
   * @returns
   */
  public async writeAppendFile(filePath: string, content: string, fOption?: {
    line: boolean;
  }): Promise<boolean> {
    return await new Promise((resolve: Function) => {
      resolve(this.writeFileAppendSync(filePath, content))
    });
  }

  /**
   * 追加的形式写文件
   * @param filePath
   * @param content
   * @returns
   */
  public writeFileAppendSync(filePath: string, content: string, fOption?: {
    line: boolean;
  }): boolean {
    let result = false
    if (!filePath || !content) {
      return result
    }
    try {
      if (fs.accessSync(filePath)) {
        let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
        let readSize = 0;
        let bufSize = 1024;
        let arrayBuffer = new ArrayBuffer(bufSize);
        let option = {
          offset: 0,
          length: bufSize
        }
        let readLen = fs.readSync(file.fd, arrayBuffer, option);
        while (readLen > 0) {
          readSize += readLen
          option.offset = readSize
          readLen = fs.readSync(file.fd, arrayBuffer, option)
        }
        if (fOption && fOption.line) {
          content = "\n" + content
        }
        fs.writeSync(file.fd, content, { offset: readSize });
        // 关闭文件
        fs.closeSync(file);
      } else {
        let file = fs.openSync(filePath, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE);
        fs.writeSync(file.fd, content);
        // 关闭文件
        fs.closeSync(file);
      }
      result = true
    } catch (err) {
      let error = err as BusinessError
      console.error(`call writeFileSync failed, error code: ${err.code}, message: ${err.message}.`);
    }
    return result
  }

  /**
   * 异步删除文件
   * @param filePath
   * @returns
   */
  public async deleteFile(filePath: string): Promise<boolean> {
    return await new Promise((resolve: Function) => {
      resolve(this.deleteFileSync(filePath))
    });
  }

  /**
   * 同步删除文件
   * @param filePath
   * @returns
   */
  public deleteFileSync(filePath: string): boolean {
    let result = false
    if (!filePath) {
      return result
    }
    try {
      fs.unlinkSync(filePath)
      result = true
    } catch (err) {
      let error = err as BusinessError
      console.error(`call writeFileSync failed, error code: ${err.code}, message: ${err.message}.`);
    }
    return result
  }

  public readFileSyncTest(filePath: string): ArrayBuffer {
    let readSize = 0;
    let bufSize = 4336;

    let arrayBuffer = new ArrayBuffer(bufSize);
    try {
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY)

      let option = {
        offset: 0,
        length: bufSize
      }
      let readLen = fs.readSync(file.fd, arrayBuffer, option)

      // 关闭文件
      fs.closeSync(file)
    } catch (err) {
      let error = err as BusinessError
      console.error(`call readFileSync failed, error code: ${err.code}, message: ${err.message}.`);
    }
    return arrayBuffer;
  }

  /**
   * 列出文件夹下所有文件名，支持递归列出所有文件名（包含子目录下），支持文件过滤，使用Promise异步回调。
   * @param path string 文件夹的应用沙箱路径。
   * @param options 文件过滤选项。默认不进行过滤。
   *                  recursion boolean 是否递归子目录下文件名，默认为false。
   *                  listNum number 列出文件名数量。当设置0时，列出所有文件，默认为0。
   *                  filter Filter 文件过滤选项。当前仅支持后缀名匹配、文件名模糊查询、文件大小过滤、最近修改时间过滤。
   * @returns
   */
  listFile(path: string, options?: ListFileOptions): Promise<string[]> {
    return fs.listFile(path, options);
  }

  /**
   * 列出文件夹下所有文件名，支持递归列出所有文件名（包含子目录下），支持文件过滤，以同步方法。
   * @param path string 文件夹的应用沙箱路径。
   * @param options 文件过滤选项。默认不进行过滤。
   *                  recursion boolean 是否递归子目录下文件名，默认为false。
   *                  listNum number 列出文件名数量。当设置0时，列出所有文件，默认为0。
   *                  filter Filter 文件过滤选项。当前仅支持后缀名匹配、文件名模糊查询、文件大小过滤、最近修改时间过滤。
   * @returns
   */
  listFileSync(path: string, options?: ListFileOptions): string[] {
    return fs.listFileSync(path, options);
  }
}

export default new FileUtils()