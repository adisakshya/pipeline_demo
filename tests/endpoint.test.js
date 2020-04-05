const request = require('supertest')
const app = require('../app')

describe('Perform successful operations', () => {

    it('should pass', async () => {
        const res = await request(app)
            .get('/api/v1/index/pass');
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toEqual(true);
        expect(res.body.error).toEqual(false);
        expect(res.body.message).toEqual('GET request served');
        expect(res.body.data).toEqual(null);
    });

    it('should pass', async () => {
        const res = await request(app)
            .post('/api/v1/index/pass');
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toEqual(true);
        expect(res.body.error).toEqual(false);
        expect(res.body.message).toEqual('POST request served');
        expect(res.body.data).toEqual(null);
    });

    it('should pass', async () => {
        const res = await request(app)
            .delete('/api/v1/index/pass');
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toEqual(true);
        expect(res.body.error).toEqual(false);
        expect(res.body.message).toEqual('DELETE request served');
        expect(res.body.data).toEqual(null);
    });

});

describe('Perform unsuccessful operations', () => {

    it('should not pass', async () => {
        const res = await request(app)
            .get('/api/v1/index/fail');
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toEqual(false);
        expect(res.body.error).toEqual(true);
        expect(res.body.message).toEqual('GET request not served');
        expect(res.body.data).toEqual(null);
    });

    it('should not pass', async () => {
        const res = await request(app)
            .post('/api/v1/index/fail');
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toEqual(false);
        expect(res.body.error).toEqual(true);
        expect(res.body.message).toEqual('POST request not served');
        expect(res.body.data).toEqual(null);
    });

    it('should not pass', async () => {
        const res = await request(app)
            .delete('/api/v1/index/fail');
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toEqual(false);
        expect(res.body.error).toEqual(true);
        expect(res.body.message).toEqual('DELETE request not served');
        expect(res.body.data).toEqual(null);
    });

});