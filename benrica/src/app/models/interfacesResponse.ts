export interface loginResponseInterface {
  access_token: string,
  token_type: string,
  expires_in: string | number,
  user: userResponseInterface,
  businesses: companyResponseInterface,
}

export interface userResponseInterface {
  id: number,
  id_businesses: number,
  user_name: string,
  email: string,
  phone_number: string | number,
  access_level:  number,
  resset_pass: string | number | null,
  deleted_at: string | number | null,
  created_at: string | number,
  updated_at: string | number | null
}

export interface collaboratorResponseInterface {
  id: number,
  employee_name: string,
  employee_email: string,
  employee_pass: string,
  employee_phone: string | number,
  employee_level: string | number,
  id_businesses: number,
  reset_pass: string | number | null,
  deleted_at: string | number | null,
  created_at: string | number,
  updated_at: string | number | null
}

export interface companyResponseInterface {
  id: number,
  exclusive: number,
  business_name: string,
  email: string,
  phone: string | number,
  cnpj: string | number,
  password: string,
  reset_pass: string | number | null,
  logo_img: null | string,
  facebook: null | string,
  instagram: null | string,
  tiktok: null | string,
  business_information: string | number | null,
  deleted_at: string | number | null,
  created_at: string | number,
  updated_at: string | number | null
}

export interface serviceResponseInterface {
  services: serviceInterface[],
}

export interface serviceInterface {
  id: number,
  service_name: string,
  service_value: string,
  service_description: string,
  service_time: string,
  id_businesses: number,
  deleted_at: string | null,
  created_at: string,
  updated_at: string | null,
  business?: companyResponseInterface,
}

export interface scheduleResponseInterface {
  id: number,
  id_user: number,
  scheduling_name_client: string,
  scheduling_date_time: string,
  scheduling_date_time_final: string,
  scheduling_phone: string | null,
  id_service: number,
  scheduling_advance_value: string | null,
  scheduling_status: number,
  deleted_at: string | null,
  created_at: string,
  updated_at: string | null,
}

export interface advertisingResponseInterface {
  id: number,
  title: string,
  image: string,
  description: string,
  id_businesses: number | string,
  position: number | string,
  deleted_at: string | null,
  created_at: string,
  updated_at: string | null,
}

export interface questionsResponseInterface {
  id: number;
  id_businesses: number;
  position: number;
  question: string;
  question_type: string;
  deleted_at: string | null;
  created_at: string;
  updated_at: string | null;
  answers?: Array<
    {
      id: number,
      id_question: number,
      answer: string,
      deleted_at: string | null,
      created_at: string,
      updated_at: string | null
    }
  >
}

export interface monthFactureProductResponseInterface {
  ano: number,
  mes: number,
  faturamento: string,
}

export interface mostFactureProductResponseInterface {
  service: serviceInterface,
  total_scheduled: number
}

export interface fastInformationResponseInterface {
  total_atendimentos_ano: number,
  total_atendimentos_mes: number,
  total_atendimentos_dia: number,
  faturamento_ano: string,
  faturamento_mes: number,
  faturamento_dia: number,
  total_cancelados: number,
}

export interface questionsResponseInterface {
  id: number;
  id_businesses: number;
  id_employee: number;
  type: string;
  price: string;
  description: string;
  date: string;
  deleted_at: string | null;
  created_at: string;
  updated_at: string | null;
}
