const express = require('express');
const router = express.Router();

/**
 * Application Controller
 */
const applicationController = require('../controllers/application/controller');

/**
 * Pass Route
 * These route mark successful operation returns STATUS CODE 200
 */
router.route('/pass')
  /**
   * GET Request Handler
   */
  .get(applicationController.passOperationOnGet)
  
  /**
   * POST Request Handler
   */
  .post(applicationController.passOperationOnPost)

/**
 * Fail Route
 * These route mark unsuccessful operation returns STATUS CODE 400
 */
router.route('/fail')
  /**
   * GET Request Handler
   */
  .get(applicationController.failOperationOnGet)
  
  /**
   * POST Request Handler
   */
  .post(applicationController.failOperationOnPost)

module.exports = router;
