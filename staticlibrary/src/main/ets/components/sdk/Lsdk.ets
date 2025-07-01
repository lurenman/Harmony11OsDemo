import testNapi from 'libstaticlibrary.so';

export class Lsdk {
  public static add(): number {
    return testNapi.add(2, 3)
  }

  public static getCurrentApplicationInfo(): string {
    return testNapi.getCurrentApplicationInfo()
  }

  public static kernelVersion(): void {
    testNapi.kernelVersion()
  }

  public static getThreadList(): void {
    testNapi.getThreadList()
  }
}