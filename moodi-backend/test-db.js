// test-db.js
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'moodi_db',
  password: '123456',
  port: 5432,
});

async function testConnection() {
  try {
    const res = await pool.query('SELECT NOW() as now');
    console.log('✅ Database connected successfully!');
    console.log('Server time:', res.rows[0].now);
  } catch (err) {
    console.error('❌ Database connection failed!');
    console.error(err.message);
  } finally {
    pool.end();
  }
}

testConnection();
