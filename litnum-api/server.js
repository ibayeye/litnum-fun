import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import helmet from "helmet";
import db from "./database/db.js";
import userRouter from "./routes/user.js";
import cors from "cors";
import morgan from "morgan";

dotenv.config();
const app = express();

// middleware
app.use(express.json());
app.use(helmet());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(morgan("dev"));

// endpoint
app.use("/api/v1/", userRouter);

// database
db();

// server
app.listen(process.env.PORT, () => {
  console.log(`Server running on http://localhost:${process.env.PORT}`);
});

