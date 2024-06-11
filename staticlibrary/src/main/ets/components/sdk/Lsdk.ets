import testNapi from 'libstaticlibrary.so';

export class Lsdk {
  public static add(): number {
    return testNapi.add(2, 3)
  }
}