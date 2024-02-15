import { createFullUserInterface } from "../models/interfacesRequest";

export class FormDataUtil {

  public static createFormData(array: [{ [key: string]: any }]) {
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

  public static createFormDataAnswers(array: [createFullUserInterface]) {
    const formData = new FormData();
    array.forEach((userData: createFullUserInterface) => {
      formData.append('user_name', userData.user_name);
      formData.append('email', userData.email);
      formData.append('phone_number', userData.phone_number.toString());
      formData.append('password', userData.password.toString());
      formData.append('access_level', userData.access_level.toString());
      formData.append('id_businesses', userData.id_businesses.toString());

      userData.all_answers.forEach((answerData) => {
        if (Array.isArray(answerData.answer)) {
          answerData.answer.forEach((checkboxValue, index) => {
            formData.append(`all_answers[${answerData.question_id}][answer][${index}]`, checkboxValue.toString());
          });
        } else {
          formData.append(`all_answers[${answerData.question_id}][answer]`, answerData.answer.toString());
        }

        formData.append(`all_answers[${answerData.question_id}][question_id]`, answerData.question_id.toString());
        formData.append(`all_answers[${answerData.question_id}][type]`, answerData.type);
      });
    });
    return formData;
  }




}
