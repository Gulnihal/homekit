const jwt = require("jsonwebtoken");
const { secretKey } = require("../config");

const auth = async (req, res, next) => {
  try {
    // Try Authorization: Bearer <token> or accessToken header
    const authHeader = req.header("Authorization");
    const tokenFromHeader = authHeader && authHeader.startsWith("Bearer ")
      ? authHeader.split(" ")[1]
      : req.header("accessToken");

    if (!tokenFromHeader) {
      return res.status(401).json({ msg: "No auth token provided, access denied." });
    }

    // Verify token
    const verified = jwt.verify(tokenFromHeader, secretKey);

    if (!verified || !verified.id) {
      return res.status(401).json({ msg: "Token verification failed." });
    }

    // Token valid: attach to request
    req.user = verified.id;
    req.token = tokenFromHeader;
    next();
  } catch (err) {
    // Expired or invalid token error
    if (err.name === "TokenExpiredError") {
      return res.status(401).json({ msg: "Token expired. Please log in again." });
    }

    if (err.name === "JsonWebTokenError") {
      return res.status(401).json({ msg: "Invalid token. Access denied." });
    }

    res.status(500).json({ error: err.message });
  }
};

module.exports = auth;
