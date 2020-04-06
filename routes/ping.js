const express = require('express');
const router = express.Router();

/**
 * Ping Route
 */
router.route('/')
  /**
   * PING application server router
   */
  .get((req, res) => {
    return res
        .status(400)
        .json({
            "success": true,
            "error": false,
            "message": "pong",
            "data": null
        });
  });

module.exports = router;
