export class FormDataUtil {

    public static createFormData(array: [{[key: string]: any}]){
        const formData = new FormData();
        array.forEach(element => {
            for (const key in element) {
                if (element.hasOwnProperty(key)) {
                    formData.append(key, element[key]);
                }
            }
        });
        return formData;
    }

}