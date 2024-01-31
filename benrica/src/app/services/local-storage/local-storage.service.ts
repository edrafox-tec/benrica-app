import { Injectable } from '@angular/core';
import { SecretUtil } from 'src/app/utils/secret-util';

@Injectable({
  providedIn: 'root'
})
export class LocalStorageService {

  private storage: Storage;

  constructor() {
    this.storage = window.localStorage
  }

  set(key: string, value: any): boolean {
    if (this.storage) {
      this.storage.setItem(key, JSON.stringify(value));
      return true;
    }
    return false;
  }

  get(key: string): any {
    if (this.storage) {
      return this.storage.getItem(key);
    }
    return null;
  }


  setEncrypt(key: string, value: any): boolean {
    if (this.storage) {
      try {
        const serializedValue = (typeof value === 'object' && value !== null) ? JSON.stringify(value) : value;
        const encryptedValue = SecretUtil.encrypt(serializedValue);
        this.storage.setItem(key, encryptedValue);
        return true;
      } catch (e) {
        console.error('Erro ao criptografar e salvar no LocalStorage:', e);
        return false;
      }
    }
    return false;
  }

  getEncrypt(key: string): any {
    if (this.storage) {
      const encryptedValue = this.storage.getItem(key);

      if (encryptedValue) {
        try {
          const decryptedValue = SecretUtil.decrypt(encryptedValue);
          if (typeof decryptedValue === 'object') {
            return decryptedValue;
          }
          return JSON.parse(decryptedValue);
        } catch (e) {
          try {
            return this.storage.getItem(key);
          } catch (error) {
            console.error('Erro ao descriptografar valor do LocalStorage:', e);
            return null;
          }
        }
      }
    }
    return null;
  }

  remove(key: string): boolean {
    if (this.storage) {
      this.storage.removeItem(key);
      return true;
    }
    return false;
  }

  clear(): boolean {
    if (this.storage) {
      this.storage.clear();
      return true;
    }
    return false;
  }

}
