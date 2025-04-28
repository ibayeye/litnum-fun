import express from "express";
import User from "../models/user.js";

export const userPlay = async (req, res) => {
    const {
        name,
        correctLit,
        wrongLit,
        correctNum,
        wrongNum,
        litResult,
        numResult,
        allResult
    } = req.body;

    if (!name) {
        return res.status(400).json({ message: "Name is required" });
    }

    try {
        // Cek apakah user sudah ada
        const existingUser = await User.findOne({ name });

        if (existingUser) {
            // Persiapkan data update
            const updateData = {};

            // Hanya update properti yang dikirimkan dan tidak null/undefined
            if (correctLit !== undefined) updateData.correctLit = correctLit;
            if (wrongLit !== undefined) updateData.wrongLit = wrongLit;
            if (correctNum !== undefined) updateData.correctNum = correctNum;
            if (wrongNum !== undefined) updateData.wrongNum = wrongNum;
            if (litResult !== undefined) updateData.litResult = litResult;
            if (numResult !== undefined) updateData.numResult = numResult;

            // Hitung ulang allResult berdasarkan data terbaru
            const newCorrectLit = correctLit !== undefined ? correctLit : existingUser.correctLit;
            const newWrongLit = wrongLit !== undefined ? wrongLit : existingUser.wrongLit;
            const newCorrectNum = correctNum !== undefined ? correctNum : existingUser.correctNum;
            const newWrongNum = wrongNum !== undefined ? wrongNum : existingUser.wrongNum;

            const newAllResult = (newCorrectLit + newCorrectNum) > 0
                ? ((newCorrectLit + newCorrectNum) /
                    (newCorrectLit + newWrongLit + newCorrectNum + newWrongNum)) * 100
                : 0;

            updateData.allResult = newAllResult;

            // Update user yang sudah ada
            const updatedUser = await User.findOneAndUpdate(
                { name },
                { $set: updateData },
                { new: true } // Mengembalikan dokumen yang sudah diupdate
            );

            return res.status(200).json(updatedUser);
        } else {
            // Buat user baru jika belum ada
            const newUser = await User.create({
                name,
                correctLit: correctLit || 0,
                wrongLit: wrongLit || 0,
                correctNum: correctNum || 0,
                wrongNum: wrongNum || 0,
                litResult: litResult || 0,
                numResult: numResult || 0,
                allResult: allResult || 0,
                __v: 0
            });

            return res.status(201).json(newUser);
        }
    } catch (error) {
        console.error("Error updating/creating user:", error);
        res.status(500).json({ message: "Error updating/creating user", error: error.message });
    }
}

// Mendapatkan data hasil berdasarkan nama
export const getUserResult = async (req, res) => {
    const { name } = req.params;

    try {
        const user = await User.findOne({ name });
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: "Error fetching user data" });
    }
}

// Mendapatkan semua hasil pengguna (untuk leaderboard)
export const getAllResults = async (req, res) => {
    try {
        const users = await User.find().sort({ allResult: -1 }); // Diurutkan berdasarkan skor tertinggi
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: "Error fetching users data" });
    }
}