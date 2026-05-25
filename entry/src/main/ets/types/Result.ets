export interface Result<T> {
  code: number;
  data: T | null;
  message: string | null;
}

export interface ResultPage<T> {
  page: number;
  size: number;
  total: number;
  records: T[];
}