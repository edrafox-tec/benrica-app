export class SecretUtil {
  public static encrypt(value: string): string {
    return btoa(value);
  }

  public static decrypt(value: string): string {
    if (value === null) {
      return value
    } else {
      return atob(value?.replace(/^"(.*)"$/, '$1'));
    }
  }
}
