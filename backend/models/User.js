import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,

  esportePrincipal: String,

  peso: Number,
  altura: Number,
  sexo: {
    type: String,
    enum: ["Masculino", "Feminino", "Outro"],
  },

  dataNascimento: Date,
  categoria: String,

  role: { type: String, default: "user" },
});

export default mongoose.model("User", userSchema);
