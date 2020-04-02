const request = require('supertest')
const app = require('../app')

describe('GET', () => {
  it('should ping the server', async () => {
    const res = await request(app)
      .get('/api/v1/ping');
    expect(res.statusCode).toEqual(200);
    expect(res.body.success).toEqual(true);
    expect(res.body.error).toEqual(false);
    expect(res.body.message).toEqual('pong');
    expect(res.body.data).toEqual(null);
  });
});