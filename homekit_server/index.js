// IMPORTS FROM PACKAGES
const express = require("express");
const logger = require("morgan");
const cookieParser = require("cookie-parser");
const bodyParser = require("body-parser");
const session = require("express-session");
const mongoose = require("mongoose");
const MongoStore = require("connect-mongo");
const cors = require("cors");
require("dotenv").config();

// IMPORT ROUTERS
const { deviceRouter } = require("./routes/device");
const authRouter = require("./routes/auth");
const userRouter = require("./routes/user");

// INIT
const { secretKey, mongoDbUrl, port } = require("./config");
const app = express();

// Middleware
app.use(logger("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(cors());
app.use(express.json());

app.use(
  session({
    secret: secretKey,
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
      mongoUrl: mongoDbUrl,
    }),
    cookie: { maxAge: 180 * 60 * 1000 },
  })
);

// Database
mongoose.connect(mongoDbUrl);
const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDB connected!");
});

// Routers
app.use(authRouter);
app.use(deviceRouter);
app.use(userRouter);

// Root
app.get("/", (req, res) => res.json("homekit server!"));

// Start
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
