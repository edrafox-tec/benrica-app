export class StringHelp {

    constructor() {
        throw new Error("Não é possível instanciar esta classe");
    }

    public static replaceParametersWithValue(url: any, param: { [key: string]: string | number | boolean }[]): string {
        param.map((param, index) => {
            url = url.replace(`:${Object.keys(param)[0]}`, param[Object.keys(param)[0]]);
        })
        return url
    }

}
