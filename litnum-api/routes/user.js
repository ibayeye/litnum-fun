import express from "express";
import { userPlay } from "../controller/user.js";

const router = express.Router();

router.post('/playUser', userPlay);

export default router;