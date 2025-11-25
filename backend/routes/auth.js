import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

const router = express.Router();

// 🧾 Cadastro
router.post("/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    let user = await User.findOne({ email });
    if (user) {
      return res.status(400).json({ message: "Usuário já existe" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    user = new User({ name, email, password: hashedPassword });
    await user.save();

    res.status(201).json({ message: "Usuário registrado com sucesso" });
  } catch (err) {
    console.log("ERRO NO CADASTRO:", err.message);
    res.status(500).json({ error: err.message });
  }
});

// 🔑 Login
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: "Credenciais inválidas" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Credenciais inválidas" });
    }

    const token = jwt.sign(
      { userId: user._id, role: user.role },
      "mysecretkey",
      { expiresIn: "1h" } // <-- faltava o 's' em expiresIn
    );

    res.status(200).json({
      message: "Login realizado com sucesso!",
      token,
      user: { name: user.name, email: user.email },
    });
  } catch (err) {
    console.error("Erro no login:", err.message);
    res.status(500).json({ error: "Erro no servidor" });
  }
});

// 👤 Listar usuários (ou o atual)
router.get("/user", async (req, res) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) return res.status(401).json({ error: "Token ausente" });

    const decoded = jwt.verify(token, "mysecretkey");

    const user = await User.findById(decoded.userId).select("-password");
    if (!user) return res.status(404).json({ error: "Usuário não encontrado" });

    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ error: "Erro no servidor" });
  }
})

export default router;
