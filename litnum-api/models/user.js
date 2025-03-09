import mongoose from "mongoose";

const { Schema } = mongoose;

const userSchema = new Schema({
    name: {
        type: String,
        required: true,
    },
    correctLit:{
        type: Number,
        required: false,
        default: "0"
    },
    wrongLit: {
        type: Number,
        required: false,
        default: "0"
    },
    correctNum:{
        type: Number,
        required: false,
        default: "0"
    },
    wrongNum: {
        type: Number,
        required: false,
        default: "0"
    },
    litResult: {
        type: Number,
        required: false,
        default: "0"
    },
    numResult: {
        type: Number,
        required: false,
        default: "0"
    },
    allResult: {
        type: Number,
        required: false,
        default: "0"
    }
});

const User = mongoose.model("User", userSchema);

export default User;