
export interface createUserInterface {
  user_name: string,
  email: string,
  phone_number: string | number,
  access_level: string | number,
  password: string | number,
  id_businesses: string | number,
}

export interface createFullUserInterface {
  user_name: string;
  email: string;
  phone_number: string | number;
  access_level: string | number;
  password: string | number;
  id_businesses: string | number;
  all_answers: Array<{
    answer: string | number | number[];
    question_id: number;
    type: string;
  }>;
}
