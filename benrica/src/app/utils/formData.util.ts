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

  public static createFormDataAnswers(array: [{ id_user: number, all_answers: [{ answer: string | number | number[], question_id: number, type: string }] }]) {
    const formData = new FormData();
    array.forEach((userData: { id_user: number, all_answers: { answer: string | number | number[], question_id: number, type: string }[] }) => {
      formData.append('id_user', userData.id_user.toString());
      userData.all_answers.forEach((answerData) => {
        formData.append(`all_answers[${answerData.question_id}][answer]`, JSON.stringify(answerData.answer));
        formData.append(`all_answers[${answerData.question_id}][question_id]`, answerData.question_id.toString());
        formData.append(`all_answers[${answerData.question_id}][type]`, answerData.type);
      });
    });
    return formData;
  }



}
