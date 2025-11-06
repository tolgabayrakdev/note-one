import express from "express";
import morgan from "morgan";
import cookieParser from "cookie-parser";
import cors from "cors";
import dotenv from "dotenv";
import db from "./database/db.js";
import authRoutes from "./routes/auth-routes.js";
import noteRoutes from "./routes/note-routes.js";

dotenv.config();

const app = express();

// Middleware
app.use(morgan("dev"));
app.use(express.json());
app.use(cookieParser());
app.use(cors({
  origin: '*', // Production'da spesifik origin belirtin
  credentials: true
}));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/notes", noteRoutes);

// Health check
app.get("/", (req, res) => {
  res.json({ message: "Note API is running" });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
    console.log("Database initialized");
});