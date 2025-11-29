import { create } from "zustand";
import { addPatient, deletePatient, getPatients, updatePatient } from "../api/patientService";

export const usePatientStore = create((set) => ({
  patients: [],
  isLoading: false,

  loadPatients: async () => {
    set({ isLoading: true });
    const data = await getPatients();
    set({ patients: data, isLoading: false });
  },

  addPatient: async (patient) => {
    const updated = await addPatient(patient);
    set({ patients: updated });
  },

  updatePatient: async (id, updated) => {
    const newList = await updatePatient(id, updated);
    set({ patients: newList });
  },

  deletePatient: async (id) => {
    const newList = await deletePatient(id);
    set({ patients: newList });
  },
}));
