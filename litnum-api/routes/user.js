import express from "express";
import { getAllResults, getUserResult, userPlay } from "../controller/user.js";

const router = express.Router();

router.post('/playUser', userPlay);
router.get('/userResult/:name', getUserResult);
router.get('/allResult', getAllResults);

export default router;