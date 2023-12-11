import { ToastOptions } from "@ionic/angular";

export interface IToastOptions extends ToastOptions{}

export type ToastPosition = "top" | "bottom" | "middle";

export type ToastColor = "primary" | "secondary" | "success" | "danger" | "warning" | "info" | "light" | "dark";
