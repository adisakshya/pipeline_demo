/**
 * Application Controller
 */

/**
 * Perform operation successfully for GET Request
 * @param {Object} req 
 * @param {Object} res 
 */
const passOperationOnGet = async (req, res) => {
    return res
      .status(400)
      .json({
        "success": true,
        "error":false,
        "message": "GET request served",
        "data": null
      });
}

/**
 * Perform operation successfully for POST Request
 * @param {Object} req 
 * @param {Object} res 
 */
const passOperationOnPost = async (req, res) => {
    return res
        .status(200)
        .json({
            "success": true,
            "error":false,
            "message": "POST request served",
            "data": null
        });
};

/**
 * Perform operation unsuccessfully for GET Request
 * @param {Object} req 
 * @param {Object} res 
 */
const failOperationOnGet = async (req, res) => {
  return res
    .status(400)
    .json({
      "success": false,
      "error":true,
      "message": "GET request not served",
      "data": null
    });
}

/**
* Perform operation unsuccessfully for POST Request
* @param {Object} req 
* @param {Object} res 
*/
const failOperationOnPost = async (req, res) => {
  return res
      .status(200)
      .json({
          "success": false,
          "error":true,
          "message": "POST request not served",
          "data": null
      });
};

exports.passOperationOnGet = passOperationOnGet;
exports.passOperationOnPost = passOperationOnPost;
exports.failOperationOnGet = failOperationOnGet;
exports.failOperationOnPost = failOperationOnPost;
