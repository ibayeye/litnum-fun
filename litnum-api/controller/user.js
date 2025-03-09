import express from "express";
import User from "../models/user.js";

export const userPlay = async (req, res) => {
    const { name } = req.body;

    if (!name) {
        return res.status(400).json({ message: "Name is required" });
    }

    try {
        const user = await User.create({ name });
        res.status(201).json(user);
    } catch {
        res.status(500).json({ message: "Error creating user" });
    }
}