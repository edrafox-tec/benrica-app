export interface loginResponseInterface {
  access_token: string,
  token_type: string,
  expires_in: string | number,
  user: userResponseInterface
}

export interface userResponseInterface {
  id: string | number,
  id_businesses: string | number,
  user_name: string,
  email: string,
  phone_number: string | number,
  access_level: string | number,
  resset_pass: string | number | null,
  deleted_at: string | number | null,
  created_at: string | number,
  updated_at: string | number | null
}

export interface collaboratorResponseInterface {
  id: string | number,
  employee_name: string,
  employee_email: string,
  employee_pass: string,
  employee_phone: string | number,
  employee_level: string | number,
  id_businesses: string | number,
  reset_pass: string | number | null,
  deleted_at: string | number | null,
  created_at: string | number,
  updated_at: string | number | null
}

export interface companyResponseInterface {
  id: string | number,
  business_name: string,
  email: string,
  phone: string | number,
  cnpj: string | number,
  password: string,
  reset_pass: string | number | null,
  logo_img: null | string,
  facebook: null | string,
  instagram: null | string,
  business_information: string | number | null,
  deleted_at: string | number | null,
  created_at: string | number,
  updated_at: string | number | null
}

export interface serviceResponseInterface {
  services: serviceInterface[];
}

export interface serviceInterface {
  id: number;
  service_name: string;
  service_value: string;
  service_description: string;
  service_time: string;
  id_businesses: number;
  deleted_at: string | null;
  created_at: string;
  updated_at: string | null;
  business: companyResponseInterface;
}

export interface scheduleResponseInterface {
  id: number,
  id_user: number,
  scheduling_name_client: string,
  scheduling_date_time: string | null,
  scheduling_phone: string | null,
  id_service: number,
  scheduling_advance_value: string | null,
  scheduling_status: string | null,
  deleted_at: string | null;
  created_at: string;
  updated_at: string | null;
}
